#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Scripts que precisam terminar ANTES de qualquer tarefa (ordem importa)
PREREQS=(
    setup-codex
)

log() {
    echo "[post-start] $*"
}

# Evita execuções concorrentes do post-start (uma espera a outra terminar)
acquire_lock() {
    if command -v flock >/dev/null 2>&1; then
        exec 9>/tmp/post-start.lock
        log "⏳ Aguardando lock..."
        flock 9
    fi
}

# Garante que o binário instalado pelo npm -g seja visto pelos próximos scripts
refresh_path() {
    if command -v npm >/dev/null 2>&1; then
        export PATH="$(npm config get prefix)/bin:$PATH"
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

    bash "$script" || {
        log "❌ Falha na tarefa: $task"
        return 1
    }

    log "✅ Concluído: $task"
}

run_prereqs() {
    local prereq
    for prereq in "${PREREQS[@]}"; do
        run_task "$prereq"
        refresh_path
    done
}

main() {
    local tasks=("$@")
    aspire certs trust 
    if [[ ${#tasks[@]} -eq 0 ]]; then
        tasks=(
            setup-codex            
            aspire-clean
        )
    fi

    acquire_lock
    run_prereqs

    for task in "${tasks[@]}"; do
        run_task "$task"
    done

    log "🎉 Post-start finalizado."
}

main "$@"