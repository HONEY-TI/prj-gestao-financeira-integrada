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
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nano \
        xterm \
        xauth \
        docker.io \
        wl-clipboard \
        xclip \
        xsel \
        bubblewrap \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*


#RUN dotnet workload update
#RUN git lfs install --system

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
    /usr/local/bin/setup/setup-shell.sh" \
    > /etc/sudoers.d/${USERNAME}-dev \
    && chmod 0440 /etc/sudoers.d/${USERNAME}-dev

# =========================================================
# STEP 6 - DOTNET RUN — AUTO LAUNCH PROFILE
# =========================================================
RUN cat >> /home/${USERNAME}/.bashrc <<'EOF'
function dotnet() {
    # Qualquer comando diferente de "run" passa direto
    if [[ "$1" != "run" ]]; then
        command dotnet "$@"
        return
    fi

    # Respeita quem já informou perfil ou projeto manualmente
    local arg
    for arg in "${@:2}"; do
        case "$arg" in
            --launch-profile|-lp|--project|--no-launch-profile)
                command dotnet "$@"
                return
                ;;
        esac
    done

    # Perfil conforme o sistema operacional
    local profile
    case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*|Windows_NT) profile="https" ;;
        Linux|Darwin)                    profile="https-container" ;;
        *)
            echo "Unsupported operating system: $(uname -s)"
            return 1
            ;;
    esac

    shift  # remove "run"

    # Projeto: argumento posicional > .csproj na pasta atual > ./AppHost
    local project_args=()
    if [[ -n "$1" && "$1" != -* ]]; then
        project_args=(--project "$1")
        shift
    elif compgen -G "*.csproj" > /dev/null; then
        :  # já está na pasta do projeto
    elif [[ -d "AppHost" ]]; then
        project_args=(--project "AppHost")
    fi

    echo "Starting ${project_args[1]:-$(basename "$PWD")} with profile: $profile"

    command dotnet run --launch-profile "$profile" "${project_args[@]}" "$@"
}
EOF

RUN chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bashrc
RUN sudo useradd -D -s /bin/bash


# =============================================================================
# 🔄 AUTO SWITCH — ROOT ➜ ubuntu
# =============================================================================
#  📌 false = DESATIVADO | true = ATIVADO
#=============================================================================
ARG ENABLE_SWITCH_USER=true
ENV ENABLE_SWITCH_USER=${ENABLE_SWITCH_USER}

RUN if [ "${ENABLE_SWITCH_USER}" = "true" ]; then \
        echo "🔄 Configurando auto switch: root ➜ ubuntu"; \
        printf '%s\n' \
            'if [ "${AUTO_SWITCHED}" != "1" ]; then' \
            '    export AUTO_SWITCHED=1' \
            '    exec su --whitelist-environment=VSCODE_IPC_HOOK_CLI,REMOTE_CONTAINERS_IPC,BROWSER,GIT_ASKPASS,VSCODE_GIT_ASKPASS_NODE,VSCODE_GIT_ASKPASS_MAIN,VSCODE_GIT_IPC_HANDLE -l ubuntu' \
            'fi' \
            > /root/.switch_user; \
        echo "source /root/.switch_user" >> /root/.bashrc; \
        echo "source /root/.switch_user" >> /root/.bash_profile; \
        echo ". /root/.switch_user" >> /root/.profile; \
    else \
        echo "⏭️  Auto switch root ➜ ubuntu: DESATIVADO"; \
    fi    

WORKDIR ${WORKSPACE}
ENTRYPOINT ["docker-entrypoint.sh"]