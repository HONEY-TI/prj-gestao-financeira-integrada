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
#ENV HOME=/home/ubuntu
#ENV UBUNTU_ROOT=/usr/share/ubuntu
#ENV PATH="/home/ubuntu/.dotnet/tools:/home/ubuntu/.npm-global/bin:/home/ubuntu/.local/bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

# =============================================================================
# STEP 2 - Pacotes do sistema
# =============================================================================

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        xterm \
        iptables \
        ipset \
        iproute2 \
        iputils-ping \
        dnsutils \
        aggregate \
        gh \
        openssh-client \
        openssh-server \
        jq \
        procps \
        xdg-utils \
        xauth \
        xclip \
        xsel \
        bubblewrap \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# =============================================================================
# STEP 3 - Diretórios do usuário ubuntu
# =============================================================================
RUN mkdir -p \
        /home/${USERNAME}/.${USERNAME}/tools \
        /home/${USERNAME}/.npm-global \
        /home/${USERNAME}/.ssh \
        /home/${USERNAME}/.config \
        /home/${USERNAME}/.cache \
        /home/${USERNAME}/.local/bin 

# =============================================================================
# STEP 4 - Antigravity
# =============================================================================
#USER ${USERNAME}
RUN wget -qO /tmp/agy-install.sh https://antigravity.google/cli/install.sh \
  && bash /tmp/agy-install.sh \
  && rm -f /tmp/agy-install.sh
#USER root

# =============================================================================
# STEP 5 - Codex
# =============================================================================
RUN git lfs install --system
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
COPY .devcontainer/scripts/start-ssh.sh /usr/local/sbin/start-ssh.sh
COPY .devcontainer/scripts/setup-ssh.sh /usr/local/sbin/setup-ssh.sh
COPY .devcontainer/scripts/setup-codex.sh /usr/local/sbin/setup-codex.sh
RUN chmod +x /usr/local/sbin/setup-ssh.sh /usr/local/sbin/start-ssh.sh

# =============================================================================
# STEP 7 - Permissões 
# =============================================================================
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN echo "${USERNAME} ALL=(root) NOPASSWD: /usr/local/sbin/start-ssh.sh, /usr/local/sbin/setup-codex.sh" \
    > /etc/sudoers.d/${USERNAME}-dev \
    && chmod 0440 /etc/sudoers.d/${USERNAME}-dev


# =============================================================================
# 📌 false = DESATIVADO | true = ATIVADO
# =============================================================================
ARG ENABLE_SWITCH_USER=true
ENV ENABLE_SWITCH_USER=${ENABLE_SWITCH_USER}

RUN if [ "$ENABLE_SWITCH_USER" = "true" ]; then \
        echo "🔄 Configurando auto switch: root ➜ ubuntu"; \
        printf '%s\n' \
            'if [ "${AUTO_SWITCHED}" != "1" ]; then' \
            '    export AUTO_SWITCHED=1' \
            '    exec su - ubuntu' \
            'fi' \
            > /root/.switch_user; \
        echo "source /root/.switch_user" >> /root/.bashrc; \
        echo "source /root/.switch_user" >> /root/.bash_profile; \
        echo ". /root/.switch_user" >> /root/.profile; \
    else \
        echo "⏭️  Auto switch root ➜ ubuntu: DESATIVADO"; \
    fi

# =============================================================================
# execução
# =============================================================================
WORKDIR ${WORKSPACE}
ENTRYPOINT ["docker-entrypoint.sh"]
