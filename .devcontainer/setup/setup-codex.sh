#!/bin/bash
#
# Prepara o Codex dentro do container:
#   1. valida o ambiente
#   2. garante autenticação (device auth, com ponte para a extensão VS Code)
#   3. valida os arquivos TOML
#   4. executa o comando recebido (exec "$@")
#
# Funciona com QUALQUER usuário (usa id -un).
#
set -Eeuo pipefail

# ==========================================================
# Usuário / caminhos
# ==========================================================
CURRENT_USER="$(id -un)"
readonly CURRENT_USER

USER_HOME="$(getent passwd "$CURRENT_USER" | cut -d: -f6)"
USER_HOME="${USER_HOME:-$HOME}"
readonly USER_HOME
export HOME="$USER_HOME"

readonly WORKSPACE="${WORKSPACE:-/workspace}"
readonly CODEX_HOME="${CODEX_HOME:-$USER_HOME/.codex}"
export CODEX_HOME
readonly CODEX_CONFIG="$CODEX_HOME/config.toml"
readonly PROJECT_CONFIG="$WORKSPACE/.codex/config.toml"
readonly LOG_PREFIX="[codex]"

if [ -w "$WORKSPACE/.codex" ] || [ -w "$WORKSPACE" ]; then
    BRIDGE_DIR="$WORKSPACE/.codex"
else
    BRIDGE_DIR="$CODEX_HOME"
fi
readonly BRIDGE_DIR
readonly DEVICE_AUTH_FILE="$BRIDGE_DIR/device-auth.json"

readonly DEVICE_URL="https://auth.openai.com/codex/device"
readonly DEVICE_CODE_TIMEOUT_SECONDS=120   # espera pelo código
readonly LOGIN_TIMEOUT_SECONDS=900         # espera pelo usuário autenticar (15 min)
readonly LOGIN_POLL_SECONDS=3
readonly IPC_SOCKET_WAIT_SECONDS="${IPC_SOCKET_WAIT_SECONDS:-5}"

# ==========================================================
# Estado (usado pelo cleanup)
# ==========================================================
LOGIN_OUTPUT=""
LOGIN_PID=""
TAIL_PID=""

# ==========================================================
# Log
# ==========================================================
log()   { echo "$LOG_PREFIX $*"; }
error() { echo "$LOG_PREFIX ERRO: $*" >&2; }

die() {
    local exit_code="$1"
    shift
    error "$*"
    exit "$exit_code"
}

on_error() {
    local exit_code="$1" line="$2" command="$3"
    echo "$LOG_PREFIX ERRO linha $line: $command (exit $exit_code)" >&2
}

# ==========================================================
# Cleanup
# ==========================================================
stop_process() {
    local pid="${1:-}"
    [[ -n "$pid" ]] || return 0
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
}

cleanup_login() {
    stop_process "$TAIL_PID"
    stop_process "$LOGIN_PID"
    rm -f "${LOGIN_OUTPUT:-}" "$DEVICE_AUTH_FILE" "$DEVICE_AUTH_FILE.tmp"
    TAIL_PID=""
    LOGIN_PID=""
    LOGIN_OUTPUT=""
}

# ==========================================================
# Ambiente
# ==========================================================
require_command() {
    local name="$1" message="$2"
    command -v "$name" >/dev/null 2>&1 || die 127 "$message"
}

prepare_environment() {
    log "setup iniciado (user: $CURRENT_USER | HOME: $HOME)"

    require_command codex   "codex não encontrado"
    require_command python3 "python3 não está instalado no container"
    require_command jq      "jq não está instalado no container"

    cd "$WORKSPACE"
    mkdir -p "$CODEX_HOME" "$BRIDGE_DIR"
    touch "$CODEX_CONFIG"
}

# ==========================================================
# Autenticação
# ==========================================================
is_authenticated() {
    codex login status >/dev/null 2>&1
}

login_is_running() {
    [[ -n "$LOGIN_PID" ]] && kill -0 "$LOGIN_PID" 2>/dev/null
}

start_login() {
    LOGIN_OUTPUT="$(mktemp)"
    codex login --device-auth > "$LOGIN_OUTPUT" 2>&1 < /dev/null &
    LOGIN_PID=$!

    # Espelha a saída do login no terminal.
    tail -n +1 -f "$LOGIN_OUTPUT" &
    TAIL_PID=$!
}

extract_device_code() {
    sed 's/\x1b\[[0-9;]*m//g' "$LOGIN_OUTPUT" \
        | grep -E '^[[:space:]]*[A-Z0-9]{4,6}-[A-Z0-9]{4,6}[[:space:]]*$' \
        | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
        | head -n 1 \
        || true
}

wait_for_device_code() {
    local attempt code

    for ((attempt = 0; attempt < DEVICE_CODE_TIMEOUT_SECONDS; attempt++)); do
        code="$(extract_device_code)"
        if [[ -n "$code" ]]; then
            printf '%s\n' "$code"
            return 0
        fi

        if ! login_is_running; then
            error "o processo de login terminou antes de gerar o código"
            return 1
        fi
        sleep 1
    done

    error "tempo esgotado esperando o device code"
    return 1
}

publish_device_auth() {
    local code="$1"
    local tmp_file="$DEVICE_AUTH_FILE.tmp"

    rm -f "$DEVICE_AUTH_FILE" "$tmp_file"

    jq -n --arg url "$DEVICE_URL" --arg code "$code" \
        '{url: $url, code: $code}' > "$tmp_file" || return 1

    chmod 600 "$tmp_file"

    jq -e --arg url "$DEVICE_URL" --arg code "$code" \
        '.url == $url and .code == $code' "$tmp_file" >/dev/null || return 1

    mv -f "$tmp_file" "$DEVICE_AUTH_FILE" || return 1
    log "device-auth publicado: $DEVICE_AUTH_FILE"
}

# ----------------------------------------------------------
# Clipboard (melhor esforço — NUNCA derruba o script)
#   1. OSC 52: o terminal do VS Code copia para o clipboard do host
#   2. xclip / xsel / wl-copy (só funcionam se houver display)
# Não há como confirmar a cópia via OSC 52; por isso o código
# também é sempre exibido em destaque.
# ----------------------------------------------------------
copy_to_clipboard() {
    local text="$1" b64

    b64="$(printf '%s' "$text" | base64 | tr -d '\n')"
    if { printf '\033]52;c;%s\a' "$b64" > /dev/tty; } 2>/dev/null; then
        log "clipboard: enviado via OSC 52 (terminal do VS Code)"
        return 0
    fi

    if [[ -n "${DISPLAY:-}" ]] && command -v xclip >/dev/null 2>&1 \
        && printf '%s' "$text" | xclip -selection clipboard >/dev/null 2>&1; then
        log "clipboard: copiado via xclip"
        return 0
    fi

    if [[ -n "${DISPLAY:-}" ]] && command -v xsel >/dev/null 2>&1 \
        && printf '%s' "$text" | xsel --clipboard --input >/dev/null 2>&1; then
        log "clipboard: copiado via xsel"
        return 0
    fi

    if [[ -n "${WAYLAND_DISPLAY:-}" ]] && command -v wl-copy >/dev/null 2>&1 \
        && printf '%s' "$text" | wl-copy >/dev/null 2>&1; then
        log "clipboard: copiado via wl-copy"
        return 0
    fi

    return 1
}

# ----------------------------------------------------------
# Browser (melhor esforço — NUNCA derruba o script)
# ----------------------------------------------------------
find_browser_helper() {
    local helper="${BROWSER:-}"

    if [[ -n "$helper" && -x "$helper" && "$helper" == *browser.sh ]]; then
        printf '%s\n' "$helper"
        return 0
    fi

    /bin/ls -t \
        /vscode/vscode-server/bin/*/bin/helpers/browser.sh \
        "$HOME"/.vscode-server/bin/*/bin/helpers/browser.sh \
        "$HOME"/.vscode-server/cli/servers/*/server/bin/helpers/browser.sh \
        2>/dev/null | head -n 1 || true
}

open_url_in_host_browser() {
    local url="$1" helper sock i

    helper="$(find_browser_helper)"
    if [[ -z "$helper" ]]; then
        log "browser.sh do VS Code não encontrado"
        return 1
    fi

    # 1) Socket IPC já presente no ambiente
    if [[ -n "${VSCODE_IPC_HOOK_CLI:-}" && -S "$VSCODE_IPC_HOOK_CLI" ]]; then
        if VSCODE_IPC_HOOK_CLI="$VSCODE_IPC_HOOK_CLI" \
            timeout 15 "$helper" "$url" >/dev/null 2>&1 </dev/null; then
            return 0
        fi
    fi

    # 2) Espera o VS Code criar algum socket IPC
    for ((i = 0; i < IPC_SOCKET_WAIT_SECONDS; i++)); do
        compgen -G '/tmp/vscode-ipc-*.sock' >/dev/null && break
        sleep 1
    done

    # 3) Tenta do socket mais novo para o mais antigo; para no primeiro que funcionar
    while IFS= read -r sock; do
        [[ -S "$sock" ]] || continue
        if VSCODE_IPC_HOOK_CLI="$sock" \
            timeout 15 "$helper" "$url" >/dev/null 2>&1 </dev/null; then
            return 0
        fi
    done < <(/bin/ls -t /tmp/vscode-ipc-*.sock 2>/dev/null || true)

    return 1
}

show_device_banner() {
    local code="$1"
    echo
    echo "$LOG_PREFIX ==============================================="
    echo "$LOG_PREFIX  1) Abra:   $DEVICE_URL"
    echo "$LOG_PREFIX  2) Código: $code"
    echo "$LOG_PREFIX ==============================================="
    echo
}

open_browser() {
    local code="$1"

    show_device_banner "$code"

    if copy_to_clipboard "$code"; then
        log "código [$code] enviado ao clipboard"
    else
        log "clipboard indisponível — copie o código manualmente: [$code]"
    fi

    if open_url_in_host_browser "$DEVICE_URL"; then
        log "navegador aberto no host"
    else
        log "não foi possível abrir o navegador — abra o link manualmente"
    fi

    return 0   # garante que set -e nunca derrube o script aqui
}

# ----------------------------------------------------------
# Espera a autenticação terminar
#   Sai quando: codex login status = OK, ou o login terminou, ou timeout.
#   Evita o "travado depois de autenticar" (não depende só do wait do PID).
# ----------------------------------------------------------
wait_for_login() {
    local elapsed=0 grace

    while (( elapsed < LOGIN_TIMEOUT_SECONDS )); do
        if is_authenticated; then
            # dá alguns segundos para o login encerrar sozinho
            for ((grace = 0; grace < 5; grace++)); do
                login_is_running || break
                sleep 1
            done
            return 0
        fi

        if ! login_is_running; then
            wait "$LOGIN_PID" 2>/dev/null || true
            LOGIN_PID=""
            is_authenticated && return 0
            error "o login terminou, mas o codex continua sem autenticação"
            return 1
        fi

        sleep "$LOGIN_POLL_SECONDS"
        elapsed=$((elapsed + LOGIN_POLL_SECONDS))
    done

    error "tempo esgotado esperando a autenticação"
    return 1
}

authenticate_with_device_code() {
    local device_code

    log "autenticação necessária — iniciando device authentication..."
    start_login

    log "aguardando device code..."
    device_code="$(wait_for_device_code)" || return 1
    log "device code detectado: [$device_code]"

    publish_device_auth "$device_code" || log "aviso: falha ao publicar device-auth"

    open_browser "$device_code"

    log "aguardando você concluir a autenticação no navegador..."
    wait_for_login || return 1

    log "autenticação concluída"
    cleanup_login
}

ensure_authenticated() {
    log "verificando autenticação..."

    if is_authenticated; then
        log "autenticação OK"
    else
        authenticate_with_device_code || die 1 "autenticação falhou"
    fi
}

# ==========================================================
# Configuração
# ==========================================================
check_project_config() {
    if [[ -f "$PROJECT_CONFIG" ]]; then
        log "configuração do projeto encontrada: $PROJECT_CONFIG"
        return 0
    fi

    log "aviso: $PROJECT_CONFIG não encontrado — seguindo sem config do projeto"
    return 1
}

validate_toml_files() {
    log "validando TOML..."

    python3 - "$@" <<'PY'
import sys
import tomllib

for path in sys.argv[1:]:
    with open(path, "rb") as f:
        tomllib.load(f)
    print(f"[codex] TOML válido: {path}")
PY
}

# ==========================================================
# Main
# ==========================================================
main() {
    trap 'on_error $? $LINENO "$BASH_COMMAND"' ERR
    trap cleanup_login EXIT

    prepare_environment
    ensure_authenticated

    if check_project_config; then
        validate_toml_files "$PROJECT_CONFIG" "$CODEX_CONFIG"
    else
        validate_toml_files "$CODEX_CONFIG"
    fi

    log "setup finalizado"

    # exec substitui o processo e o trap EXIT não dispara.
    cleanup_login
    trap - EXIT

    if [[ $# -gt 0 ]]; then
        exec "$@"
    fi
}

main "$@"