#!/bin/bash

set -Eeuo pipefail

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
    echo "[tools] $*"
}

install_tool() {
    local tool="$1"
    local installer="$TOOLS_DIR/${tool}.sh"

    if [[ ! -f "$installer" ]]; then
        log "❌ Instalador não encontrado: $installer"
        return 1
    fi

    log "📦 Instalando ${tool}..."

    if ! bash "$installer"; then
        log "❌ Falha na instalação: ${tool}"
        return 1
    fi

    log "✅ ${tool} instalado com sucesso."
}

main() {
    local tools=("$@")

    if [[ ${#tools[@]} -eq 0 ]]; then
        tools=(
            tool-codex
            tool-antigravity
        )
    fi

    for tool in "${tools[@]}"; do
        install_tool "$tool"
    done

    log "🎉 Todas as ferramentas foram processadas."
}

main "$@"
