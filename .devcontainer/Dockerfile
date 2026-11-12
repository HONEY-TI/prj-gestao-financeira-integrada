FROM alexfariakof/dotnet-sdk-10-with-node:latest
USER root
ARG USERNAME=ubuntu
ENV USERNAME=${USERNAME}
ARG WORKSPACE=/workspace
ENV WORKSPACE=${WORKSPACE}

# =============================================================================
# STEP 1 - Ambiente
# =============================================================================

ENV DEBIAN_FRONTEND=noninteractive

# =============================================================================
# STEP 2 - Pacotes do sistema
# =============================================================================

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        xdg-utils \
        xauth \
        xclip \
        xsel \
        bubblewrap \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install --system

# =============================================================================
# STEP 5 - Codex
# =============================================================================
RUN npm install -g @openai/codex@latest --include=optional \
    && codex --version
   
# =============================================================================
# STEP 6 - SSH
# =============================================================================
RUN mkdir -p /home/${USERNAME}/.ssh \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh \
    && chmod 700 /home/${USERNAME}/.ssh \
    && mkdir -p /var/run/sshd

RUN mkdir -p /home/${USERNAME}/.vscode-server  \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.vscode-server  \
    && chmod 700 /home/${USERNAME}/.vscode-server 

# Scripts de configuração do SSH server (executados via postStartCommand do
# devcontainer, NÃO via ENTRYPOINT — ver docs/ssh-access.md)
COPY .devcontainer/scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY .devcontainer/scripts/setup-codex.sh /usr/local/sbin/setup-codex.sh
COPY .devcontainer/scripts/setup-antigravity.sh /usr/local/sbin/setup-antigravity.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/sbin/setup-codex.sh  && \
    chmod +x /usr/local/sbin/setup-antigravity.sh   



# =============================================================================
# STEP 7 - Permissões 
# =============================================================================
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN echo "${USERNAME} ALL=(root) NOPASSWD: /usr/local/sbin/setup-codex.sh, /usr/local/sbin/setup-antigravity.sh" \
    > /etc/sudoers.d/${USERNAME}-dev \
    && chmod 0440 /etc/sudoers.d/${USERNAME}-dev

WORKDIR ${WORKSPACE}
ENTRYPOINT ["docker-entrypoint.sh"]