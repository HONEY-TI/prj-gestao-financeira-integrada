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

# Volumes nomeados nascem como root; garante o dono nos diretórios que o usuário escreve.
HOME_DIR="/home/$APP_USER"
for d in "" .ssh .vscode-server .codex .aspnet shell_history; do
    [ -e "$HOME_DIR/$d" ] || mkdir -p "$HOME_DIR/$d"
    chown -R "$APP_USER:" "$HOME_DIR/$d" 2>/dev/null || true
done
chmod 700 "$HOME_DIR/.ssh" 2>/dev/null || true

exec "$@"
