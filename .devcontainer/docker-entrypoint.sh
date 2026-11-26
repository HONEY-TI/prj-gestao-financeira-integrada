
#!/bin/bash
set -e

APP_USER="${USERNAME:-ubuntu}"
PROJECT_WORKSPACE="${WORKSPACE:-/workspace}"

# Sem root não há o que ajustar
if [ "$(id -u)" -ne 0 ]; then
    exec "$@"
fi

if ! id "$APP_USER" >/dev/null 2>&1; then
    echo "[entrypoint] usuário '$APP_USER' não existe; seguindo sem ajustes"
    exec "$@"
fi

APP_GROUP="$(id -gn "$APP_USER")"

# ==========================================
# SINCRONIZAÇÃO UID/GID DO WORKSPACE
# ==========================================
if [ -d "$PROJECT_WORKSPACE" ]; then
    HOST_UID=$(stat -c '%u' "$PROJECT_WORKSPACE")
    HOST_GID=$(stat -c '%g' "$PROJECT_WORKSPACE")

    CURRENT_UID=$(id -u "$APP_USER")
    CURRENT_GID=$(id -g "$APP_USER")

    echo "[entrypoint] $PROJECT_WORKSPACE pertence a ${HOST_UID}:${HOST_GID}; '$APP_USER' é ${CURRENT_UID}:${CURRENT_GID}"

    # Nunca transformar o usuário da aplicação em root.
    if [ "$HOST_GID" -ne 0 ] && [ "$HOST_GID" != "$CURRENT_GID" ]; then
        echo "[entrypoint] ajustando GID de '$APP_GROUP' para $HOST_GID"
        groupmod -o -g "$HOST_GID" "$APP_GROUP"
    fi

    if [ "$HOST_UID" -ne 0 ] && [ "$HOST_UID" != "$CURRENT_UID" ]; then
        echo "[entrypoint] ajustando UID de '$APP_USER' para $HOST_UID"
        usermod -o -u "$HOST_UID" "$APP_USER"
    fi

    APP_GROUP="$(id -gn "$APP_USER")"
fi

# ==========================================
# Verifica arquivo de autenticação Xwayland
# ==========================================
XAUTH_FILE="${PROJECT_WORKSPACE}/.cache/.xauth-devc"

if [ -f "$XAUTH_FILE" ]; then
    echo "[entrypoint] arquivo Xauthority encontrado: $XAUTH_FILE"
else
    echo "[entrypoint] arquivo Xauthority não encontrado"
fi


# ==========================================
# GIT CONFIG
# ==========================================
HOME_DIR="/home/$APP_USER"
mkdir -p "$HOME_DIR"

# safe.directory no nível do sistema: vale para root e para $APP_USER.
# O grep evita duplicar a entrada a cada reinício do container.
if ! git config --system --get-all safe.directory | grep -qxF "$PROJECT_WORKSPACE"; then
    git config --system --add safe.directory "$PROJECT_WORKSPACE"
fi

# Identidade gravada no home do usuário da aplicação, não no /root.
GITCONFIG="$HOME_DIR/.gitconfig"
git config --file "$GITCONFIG" user.name  "Alex Ribeiro de Faria"
git config --file "$GITCONFIG" user.email "135660435+alexribeirofaria@users.noreply.github.com"
chown "$APP_USER:$APP_GROUP" "$GITCONFIG"
# ==========================================
# NPM CONFIG
# ==========================================
npm config --location=global delete global
npm config --location=global get global
npm config get prefix

# ==========================================
# HOME / VOLUMES NOMEADOS
# ==========================================
HOME_DIR="/home/$APP_USER"

for d in "" .ssh .vscode-server .codex .aspnet shell_history; do
    [ -e "$HOME_DIR/$d" ] || mkdir -p "$HOME_DIR/$d"
    chown -R "$APP_USER:$APP_GROUP" "$HOME_DIR/$d" 2>/dev/null || true
done

chmod 700 "$HOME_DIR/.ssh" 2>/dev/null || true

# ==========================================
# DOCKER SOCKET (daemon do host)
# ==========================================
DOCKER_SOCK="/var/run/docker.sock"
if [ -S "$DOCKER_SOCK" ]; then
    SOCK_GID="$(stat -c '%g' "$DOCKER_SOCK")"
    if [ "$SOCK_GID" -ne 0 ]; then
        SOCK_GROUP="$(getent group "$SOCK_GID" | cut -d: -f1)"
        if [ -z "$SOCK_GROUP" ]; then
            SOCK_GROUP="docker-host"
            groupadd -g "$SOCK_GID" "$SOCK_GROUP"
        fi
        usermod -aG "$SOCK_GROUP" "$APP_USER"
        echo "[entrypoint] '$APP_USER' adicionado ao grupo '$SOCK_GROUP' (GID $SOCK_GID)"
    else
        echo "[entrypoint] socket pertence ao root (GID 0); ajuste manualmente"
    fi
else
    echo "[entrypoint] $DOCKER_SOCK não encontrado"
fi
# ==========================================
# EXECUÇÃO
# ==========================================
exec "$@"