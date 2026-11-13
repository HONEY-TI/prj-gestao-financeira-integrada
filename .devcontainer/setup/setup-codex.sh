#!/usr/bin/env bash
#
# Prepara o Codex dentro do container:
#   1. valida o ambiente
#   2. garante autenticação (device auth, com ponte para a extensão VS Code)
#   3. marca o workspace como trusted
#   4. valida os arquivos TOML
#   5. executa o comando recebido (exec "$@")
#
# Funciona com QUALQUER usuário: usa o usuário que está logado (id -un).
# Todos os argumentos recebidos são repassados ao comando final (exec "$@").
#
set -Eeuo pipefail

# ==========================================================
# Usuário atual (qualquer usuário, sem valor fixo)
# ==========================================================
CURRENT_USER="$(id -un)"
readonly CURRENT_USER

# HOME vem do /etc/passwd, não do ambiente (que pode estar como /root).
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

# Ponte de device-auth: grava em /workspace se possível, senão no CODEX_HOME.
if [ -w "$WORKSPACE/.codex" ] || [ -w "$WORKSPACE" ]; then
    BRIDGE_DIR="$WORKSPACE/.codex"
else
    BRIDGE_DIR="$CODEX_HOME"
fi
readonly BRIDGE_DIR
readonly DEVICE_AUTH_FILE="$BRIDGE_DIR/device-auth.json"

readonly DEVICE_URL="https://auth.openai.com/codex/device"
readonly DEVICE_CODE_REGEX='\b[A-Z0-9]{4,6}-[A-Z0-9]{4,6}\b'
readonly DEVICE_CODE_TIMEOUT_SECONDS=120

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
    local pid="$1"
    [[ -n "$pid" ]] && kill "$pid" 2>/dev/null || true
}

cleanup_login() {
    stop_process "$TAIL_PID"
    stop_process "$LOGIN_PID"
    rm -f "$LOGIN_OUTPUT" "$DEVICE_AUTH_FILE" "$DEVICE_AUTH_FILE.tmp"
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

log_environment() {
    log "setup iniciado"
    log "user: $CURRENT_USER"
    log "HOME: $HOME"
    log "PATH: $PATH"
}

prepare_environment() {
    require_command codex   "codex não encontrado"
    require_command python3 "python3 não está instalado no container"

    cd "$WORKSPACE"
    mkdir -p "$CODEX_HOME" "$BRIDGE_DIR"
    touch "$CODEX_CONFIG"
    #rm -f "$DEVICE_AUTH_FILE"
}

# ==========================================================
# Autenticação
# ==========================================================

is_authenticated() {
    codex login status >/dev/null 2>&1
}

start_login() {
    LOGIN_OUTPUT="$(mktemp)"
    codex login --device-auth > "$LOGIN_OUTPUT" 2>&1 &
    LOGIN_PID=$!

    # Espelha a saída do login no terminal.
    tail -f "$LOGIN_OUTPUT" &
    TAIL_PID=$!
}

login_is_running() {
    kill -0 "$LOGIN_PID" 2>/dev/null
}

extract_device_codev1() {
    sed 's/\x1b\[[0-9;]*m//g' "$LOGIN_OUTPUT" \
        | grep -Eo '[A-Z0-9]{4,6}-[A-Z0-9]{4,6}' \
        | tail -n 1 \
        || true
}

extract_device_code() {
    sed 's/\x1b\[[0-9;]*m//g' "$LOGIN_OUTPUT" \
        | grep -E '^[[:space:]]*[A-Z0-9]{4,6}-[A-Z0-9]{4,6}[[:space:]]*$' \
        | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
        | head -n 1 \
        || true
}

wait_for_device_code() {
    local attempt
    local code

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


open_browser() {    
    local url="${DEVICE_URL:-https://auth.openai.com/codex/device}"
    local helper sock i    
    local published_code

    # espera até 30s o VS Code criar o socket IPC
    for ((i = 0; i < 30; i++)); do
        compgen -G '/tmp/vscode-ipc-*.sock' >/dev/null && break
        sleep 1
    done

    # Aguarda até 30 segundos pela confirmação da cópia
    published_code="$(extract_device_code)"
    CLIPBOARD_CONFIRMED=0

    for ((i = 0; i < 15; i++)); do
        if copy_to_clipboard "$published_code"; then
            CLIPBOARD_CONFIRMED=1
            break
        fi
        sleep 1
    done

    if [[ "$CLIPBOARD_CONFIRMED" -eq 1 ]]; then
        log "código copiado com sucesso: [$published_code]"
    else
        log "clipboard indisponível após 30 segundos. Código: [$published_code]"
    fi

    if [[ "$CLIPBOARD_CONFIRMED" -eq 1 ]]; then
        log "código confirmado no clipboard"
    else
        log "não foi possível confirmar o clipboard após 30 segundos"
    fi

    helper="${BROWSER:-}"
    if [[ -z "$helper" || ! -x "$helper" || "$helper" != *browser.sh ]]; then
        helper="$(/bin/ls -t \
            /vscode/vscode-server/bin/*/bin/helpers/browser.sh \
            "$HOME"/.vscode-server/bin/*/bin/helpers/browser.sh \
            2>/dev/null | head -n 1 || true)"
    fi    
    [[ -n "$helper" ]] || return 1

    if [[ -n "${VSCODE_IPC_HOOK_CLI:-}" && -S "$VSCODE_IPC_HOOK_CLI" ]]; then
        VSCODE_IPC_HOOK_CLI="$VSCODE_IPC_HOOK_CLI" timeout 10 "$helper" "$url" >/dev/null 2>&1 </dev/null && return 0
    fi

    while IFS= read -r sock; do
        VSCODE_IPC_HOOK_CLI="$sock" timeout 10 "$helper" "$url" >/dev/null 2>&1 </dev/null && return 0
    done < <(/bin/ls -t /tmp/vscode-ipc-*.sock 2>/dev/null || true)
    
    env -u VSCODE_IPC_HOOK_CLI -u BROWSER bash -c 'H=$(/bin/ls -t ~/.vscode-server/bin/*/bin/helpers/browser.sh | head -n 1); for S in $(/bin/ls -t /tmp/vscode-ipc-*.sock); do echo "tentando $S"; VSCODE_IPC_HOOK_CLI="$S" timeout 10 "$H" "https://auth.openai.com/codex/device"; echo "exit=$?"; done'
}

publish_device_auth() {
    local code="$1"
    local tmp_file="$DEVICE_AUTH_FILE.tmp"

    log "publicando device code: [$code]"

    rm -f "$DEVICE_AUTH_FILE" "$tmp_file" || {
        log "erro ao remover device-auth anterior"
        return 1
    }

    # Gera JSON usando jq para escapar corretamente os valores.
    if ! jq -n \
        --arg url "$DEVICE_URL" \
        --arg code "$code" \
        '{url: $url, code: $code}' > "$tmp_file"; then
        log "erro ao gerar JSON de device-auth"
        return 1
    fi

    chmod 600 "$tmp_file"

    if ! jq -e \
        --arg url "$DEVICE_URL" \
        --arg code "$code" \
        '.url == $url and .code == $code' \
        "$tmp_file" >/dev/null; then
        log "erro: validação do JSON temporário falhou"
        return 1
    fi

    if ! mv -f "$tmp_file" "$DEVICE_AUTH_FILE"; then
        log "erro ao publicar device-auth"
        return 1
    fi

    log "device-auth publicado e validado: $DEVICE_AUTH_FILE"
}

# ------------------------------------------------------
# Clipboard
# ------------------------------------------------------
copy_to_clipboard() {
    local text="$1"

    if command -v xclip >/dev/null 2>&1 \
        && printf '%s' "$text" | xclip -selection clipboard >/dev/null 2>&1; then
        log "device code copiado para o clipboard (xclip)"
        return 0
    fi

    if command -v xsel >/dev/null 2>&1 \
        && printf '%s' "$text" | xsel --clipboard --input >/dev/null 2>&1; then
        log "device code copiado para o clipboard (xsel)"
        return 0
    fi

    return 1
}

authenticate_with_device_code() {
    local device_code

    log "autenticação necessária"
    log "iniciando device authentication..."
    start_login

    log "aguardando device code..."
    device_code="$(wait_for_device_code)" || exit 1
    log "device code detectado: [$device_code]"

    publish_device_auth "$device_code" &
    TASK_PID=$!

    if wait "$TASK_PID"; then
        log "publicação concluída"
    else
        log "erro na publicação"
        return 1
    fi
    # ------------------------------------------------------
    # Abre o navegador somente após validar a publicação
    # ------------------------------------------------------
    log "abrindo navegador..."
    log "abra: $DEVICE_URL"
    open_browser

    log "solicitação enviada para VS Code"
    log "navegador será aberto no host"
    log "código será copiado para o clipboard"
    log "aguardando autenticação..."

    wait "$LOGIN_PID" || die 1 "autenticação falhou"
    log "autenticação concluída"

    cleanup_login
}

ensure_authenticated() {
    log "verificando autenticação..."

    if is_authenticated; then
        log "autenticação OK"
    else
        authenticate_with_device_code
    fi
}

# ==========================================================
# Configuração
# ==========================================================
#
# O config.toml do projeto ($WORKSPACE/.codex/config.toml) é OPCIONAL.
# Quando não existe, apenas registramos um aviso e seguimos em frente,
# validando somente o config.toml do usuário (CODEX_CONFIG).

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

    log "configuração concluída"
    log "setup finalizado"

    # exec substitui o processo e o trap EXIT não dispara,
    # então limpamos explicitamente antes.
    cleanup_login
    trap - EXIT

    if [[ $# -gt 0 ]]; then
        exec "$@"
    fi
}

main "$@"