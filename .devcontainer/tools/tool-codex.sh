#!/bin/bash

set -e pipefail

log() {
    echo "[codex] $*"
}

codex_install() {
    if command -v codex >/dev/null 2>&1; then
        log "✅ Codex já instalado: $(codex --version)"
        return 0
    fi

    log "🚀 Instalando Codex..."

    # Instalação global exige root; se não for root, tenta via sudo
    local SUDO=""
    if [[ "$(id -u)" -ne 0 ]] && command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    fi

    $SUDO npm install -g @openai/codex@latest --include=optional || {
        log "❌ Falha ao instalar Codex."
        return 1
    }

    hash -r   # limpa o cache de comandos do bash

    if ! command -v codex >/dev/null 2>&1; then
        log "❌ Executável Codex não encontrado no PATH."
        log "   prefix do npm: $(npm config get prefix)"
        return 1
    fi

    local version
    version="$(codex --version)" || {
        log "❌ Falha ao validar Codex."
        return 1
    }

    [[ -n "$version" ]] || {
        log "❌ Versão do Codex vazia."
        return 1
    }

    log "✅ Codex instalado e validado: $version"
}

codex_install