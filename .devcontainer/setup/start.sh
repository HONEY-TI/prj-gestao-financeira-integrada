#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Scripts que precisam terminar ANTES das demais tarefas (ordem importa)
PREREQS=()

# Tarefas padrão (sem duplicar o que está em PREREQS)
DEFAULT_TASKS=(
    setup-dev-certs
    setup-codex    
)

log() {
    echo "[post-start] $*"
}

acquire_lock() {
    if command -v flock >/dev/null 2>&1; then
        exec 9>/tmp/post-start.lock
        log "⏳ Aguardando lock..."
        flock 9
    else
        log "⚠️ flock não encontrado, seguindo sem lock"
    fi
}

refresh_path() {
    if command -v npm >/dev/null 2>&1; then
        local prefix
        if prefix="$(npm config get prefix 2>/dev/null)"; then
            export PATH="$prefix/bin:$PATH"
        fi
    fi
    hash -r
}

run_task() {
    local task="$1"
    local script="$SCRIPT_DIR/${task}.sh"

    if [[ ! -f "$script" ]]; then
        log "❌ Script não encontrado: $script"
        return 1
    fi

    log "▶️ Executando: $task"

    if bash "$script"; then
        log "✅ Concluído: $task"
    else
        log "❌ Falha na tarefa: $task"
        return 1
    fi
}

main() {
    local tasks=("$@")
    if [[ ${#tasks[@]} -eq 0 ]]; then
        tasks=("${DEFAULT_TASKS[@]}")
    fi

    acquire_lock    
    # Não deixa falha de certificado derrubar o container
    aspire certs trust || log "⚠️ Falha ao confiar no certificado (seguindo)"

    local item
    for item in "${PREREQS[@]}"; do
        run_task "$item"
        refresh_path
    done

    # Tarefas não críticas não devem derrubar o postStart
    for item in "${tasks[@]}"; do
        run_task "$item" || log "⚠️ Tarefa falhou, continuando: $item"
    done

    log "🎉 Post-start finalizado."
}

main "$@"