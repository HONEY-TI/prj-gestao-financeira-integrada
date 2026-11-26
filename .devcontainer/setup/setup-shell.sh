#!/bin/bash

set -e

# ==========================================================
# Usuário atual (qualquer usuário, sem valor fixo)
# ==========================================================

USERNAME="${USERNAME:-node}"

if id "$USERNAME" >/dev/null 2>&1; then
    CURRENT_USER="$USERNAME"
else
    CURRENT_USER="$(id -un 2>/dev/null || id -u)"
fi

readonly CURRENT_USER

# ==========================================================
# Detecta o shell do usuário
# ==========================================================

detect_user_shell() {
    local candidate=""
    local configured_shell=""

    if command -v getent >/dev/null 2>&1; then
        configured_shell="$(getent passwd "$CURRENT_USER" 2>/dev/null | cut -d: -f7 || true)"
    fi

    for candidate in \
        "$configured_shell" \
        "${SHELL:-}" \
        "$(command -v bash 2>/dev/null || true)" \
        "$(command -v zsh 2>/dev/null || true)" \
        "$(command -v sh 2>/dev/null || true)"; do

        [ -n "$candidate" ] || continue
        [ -x "$candidate" ] || continue

        case "${candidate##*/}" in
            bash|zsh|sh|dash|ash|fish)
                printf '%s\n' "$candidate"
                return 0
                ;;
        esac
    done

    return 1
}

# ==========================================================
# Garante o comando resize (pacote xterm)
# ==========================================================

ensure_xterm() {
    local SUDO=""
    local APT_OPTS=(-o DPkg::Lock::Timeout=120)

    if command -v resize >/dev/null 2>&1; then
        return 0
    fi

    if [ "$(id -u)" -ne 0 ]; then
        if command -v sudo >/dev/null 2>&1; then
            SUDO="sudo"
        else
            echo "[open-user-shell] Aviso: sem root e sem sudo." >&2
            return 0
        fi
    fi

    if ! command -v apt-get >/dev/null 2>&1; then
        echo "[open-user-shell] Aviso: apt-get indisponível." >&2
        return 0
    fi

    echo "[open-user-shell] Verificando instalação do xterm..." >&2

    if ! $SUDO env DEBIAN_FRONTEND=noninteractive \
        apt-get "${APT_OPTS[@]}" update; then

        echo "[open-user-shell] Aviso: apt-get update falhou." >&2
    fi

    if $SUDO env DEBIAN_FRONTEND=noninteractive \
        apt-get "${APT_OPTS[@]}" install -y --no-install-recommends xterm; then

        echo "[open-user-shell] xterm instalado." >&2
    else
        echo "[open-user-shell] Aviso: não foi possível instalar xterm." >&2
    fi

    return 0
}

# ==========================================================
# Detecta shell
# ==========================================================

user_shell="$(detect_user_shell)" || {
    echo "[open-user-shell] Nenhum shell compatível encontrado para $CURRENT_USER." >&2
    exit 127
}

# ==========================================================
# Configuração do terminal
# ==========================================================

export TERM="${TERM:-xterm-256color}"
export COLORTERM="${COLORTERM:-truecolor}"

# ==========================================================
# Ajusta TTY para aplicações TUI
# ==========================================================

if [ -t 0 ] && [ -t 1 ]; then

    if ! command -v resize >/dev/null 2>&1; then
        ensure_xterm
    fi

    if command -v resize >/dev/null 2>&1; then
        eval "$(resize -s 2>/dev/null)" || true
    fi

    if command -v clear >/dev/null 2>&1; then
        clear 2>/dev/null || true
    fi

fi

# ==========================================================
# Inicia shell de login
# ==========================================================

case "${user_shell##*/}" in
    bash|zsh|fish)
        exec "$user_shell" -l
        ;;

    *)
        exec "$user_shell"
        ;;
esac
