#!/bin/bash
set -e

APP_USER="${USERNAME:-ubuntu}"
PROJECT_WORKSPACE="${WORKSPACE:-/workspace}"

# Sem root não há o que ajustar
if [ "$(id -u)" -ne 0 ]; then exec "$@"; fi

if ! id "$APP_USER" >/dev/null 2>&1; then
    echo "[entrypoint] usuário '$APP_USER' não existe; seguindo sem ajustes"
    exec "$@"
fi

if [ -d "$PROJECT_WORKSPACE" ]; then
    HOST_UID=$(stat -c '%u' "$PROJECT_WORKSPACE")
    HOST_GID=$(stat -c '%g' "$PROJECT_WORKSPACE")
    CURRENT_UID=$(id -u "$APP_USER")
    CURRENT_GID=$(id -g "$APP_USER")
    APP_GROUP=$(id -gn "$APP_USER")

    echo "[entrypoint] $PROJECT_WORKSPACE pertence a ${HOST_UID}:${HOST_GID}; '$APP_USER' é ${CURRENT_UID}:${CURRENT_GID}"

    # Dono root (0) acontece em alguns bind mounts: nunca transformar o usuário em root.
    if [ "$HOST_GID" != "0" ] && [ "$HOST_GID" != "$CURRENT_GID" ]; then
        echo "[entrypoint] ajustando GID de '$APP_GROUP' para $HOST_GID"
        groupmod -o -g "$HOST_GID" "$APP_GROUP"
    fi
    if [ "$HOST_UID" != "0" ] && [ "$HOST_UID" != "$CURRENT_UID" ]; then
        echo "[entrypoint] ajustando UID de '$APP_USER' para $HOST_UID"
        usermod -o -u "$HOST_UID" "$APP_USER"
    fi
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
git config --global user.name "Alex Ribeiro de Faria"
git config --global user.email "135660435+alexribeirofaria@users.noreply.github.com"

# ==========================================
# NPM CONFIG
# ==========================================
npm config --location=global delete global
npm config --location=global get global
npm config get prefix

# Verifica arquivo de autenticação Xwayland
XAUTH_FILE="${PROJECT_WORKSPACE}/.cache/.xauth-devc"
if [ -f "$XAUTH_FILE" ]; then
    echo "[entrypoint] arquivo Xauthority encontrado: $XAUTH_FILE"
else
    echo "[entrypoint] arquivo Xauthority não encontrado"
fi

# ==========================================
# Volumes nomeados nascem como root; garante o dono nos diretórios que o usuário escreve.
# ==========================================
HOME_DIR="/home/$APP_USER"
chown "$APP_USER:" "$HOME_DIR" 2>/dev/null || true   # sem -R

for d in "" .ssh .vscode-server .codex .aspnet shell_history; do
    [ -e "$HOME_DIR/$d" ] || mkdir -p "$HOME_DIR/$d"
    chown -R "$APP_USER:" "$HOME_DIR/$d" 2>/dev/null || true
done
chmod 700 "$HOME_DIR/.ssh" 2>/dev/null || true
exec "$@"
