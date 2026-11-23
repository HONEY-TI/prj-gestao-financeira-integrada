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
        xauth \
        wl-clipboard \
        xclip \
        xsel \
        bubblewrap \
        jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install --system

# =============================================================================
# STEP 3 - SSH
# =============================================================================
RUN mkdir -p /home/${USERNAME}/.ssh \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh \
    && chmod 700 /home/${USERNAME}/.ssh \
    && mkdir -p /var/run/sshd

RUN mkdir -p /home/${USERNAME}/.vscode-server  \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.vscode-server  \
    && chmod 700 /home/${USERNAME}/.vscode-server 

# =============================================================================
# STEP 4 Scripts de configuração
# =============================================================================
COPY .devcontainer/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY .devcontainer/setup /usr/local/bin/setup
COPY .devcontainer/tools /usr/local/bin/tools

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/setup/*.sh \
    && chmod +x /usr/local/bin/tools/*.sh
ENV PATH="/usr/local/bin/tools:${PATH}"
ENV PATH="/usr/local/bin/setup:${PATH}"

# =============================================================================
#  STEP 5 - Permissões 
# =============================================================================
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN echo "${USERNAME} ALL=(root) NOPASSWD: /usr/local/bin/tools/tool-install.sh,  /usr/local/bin/setup/start.sh \
    /usr/local/bin/open-user-shell.sh" \
    > /etc/sudoers.d/${USERNAME}-dev \
    && chmod 0440 /etc/sudoers.d/${USERNAME}-dev

# =========================================================
# STEP 6 - DOTNET RUN — AUTO LAUNCH PROFILE
# =========================================================

RUN cat >> /home/${USERNAME}/.bashrc <<'EOF'

function dotnet() {
    local cmd="$1"
    local project="$2"
    local PROFILE

    if [[ "$cmd" == "run" ]]; then
        case "$(uname -s)" in
            MINGW*|MSYS*|CYGWIN*|Windows_NT)
                PROFILE="https"
                ;;
            Linux|Darwin)
                PROFILE="https-container"
                ;;
            *)
                echo "Unsupported operating system: $(uname -s)"
                return 1
                ;;
        esac

        [[ -z "$project" || "$project" == "AppHost" ]] && project="AppHost"

        echo "Starting $project with profile: $PROFILE"

        command dotnet restore 
        command dotnet run \
            --launch-profile "$PROFILE" \
            --project "$project" \
            "${@:3}"
    else
        command dotnet "$@"
    fi
}
EOF

RUN chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bashrc
RUN sudo useradd -D -s /bin/bash

WORKDIR ${WORKSPACE}
ENTRYPOINT ["docker-entrypoint.sh"]