#!/bin/bash

set -Eeuo pipefail

log() {
    echo "[antigravity] $*"
}

antigravity_install() {
    if command -v agy >/dev/null 2>&1; then
        log "✅ Antigravity já instalado: $(agy --version)"
        return 0
    fi

    log "🚀 Instalando Antigravity..."

    if ! command -v agy >/dev/null 2>&1; then
        wget -qO /tmp/agy-install.sh https://antigravity.google/cli/install.sh
        bash /tmp/agy-install.sh
        rm -f /tmp/agy-install.sh
    fi
    
    log "✅ Antigravity instalado: $(agy --version)"
}

antigravity_install
