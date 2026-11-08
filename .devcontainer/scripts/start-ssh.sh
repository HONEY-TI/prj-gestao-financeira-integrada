#!/bin/bash
# =============================================================================
# start-ssh.sh
# Chamado pelo "postStartCommand" do devcontainer (via sudo), a cada start
# do container — NUNCA pelo ENTRYPOINT/docker-entrypoint.sh, que permanece
# intocado.
# =============================================================================
set -e

if [ "${SSH_ENABLE:-true}" != "true" ]; then
    echo "⏭️  [start-ssh] SSH server DESATIVADO (SSH_ENABLE=false)."
    exit 0
fi

/usr/local/sbin/setup-ssh.sh

# Idempotente: se o container só foi reiniciado (não recriado), o sshd
# pode já estar rodando — não sobe uma segunda instância.
if pgrep -x sshd > /dev/null; then
    echo "ℹ️  [start-ssh] sshd já está em execução, nada a fazer."
else
    /usr/sbin/sshd
    echo "🔐 [start-ssh] SSH server iniciado."
fi