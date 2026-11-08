#!/bin/bash
# =============================================================================
# setup-ssh.sh
# Configura o servidor SSH (sshd) em runtime, usando variáveis de ambiente
# que vêm do arquivo .env (injetadas pelo docker-compose).
#
# ⚠️ IMPORTANTE: este devcontainer monta o ~/.ssh do HOST direto em
# /home/ubuntu/.ssh (bind mount, sem readonly). Por isso a chave autorizada
# NUNCA é escrita dentro de $HOME — ela vai para /etc/ssh/authorized_keys,
# que é 100% interno ao container e não existe no host.
# =============================================================================
set -e

# -----------------------------------------------------------------------------
# Variáveis de ambiente (com valores padrão caso não venham do .env)
# -----------------------------------------------------------------------------
SSH_PORT="${SSH_PORT:-2222}"
SSH_USERNAME="${SSH_USERNAME:-${USERNAME:-ubuntu}}"
SSH_PASSWORD="${SSH_PASSWORD:-}"
SSH_PUBLIC_KEY="${SSH_PUBLIC_KEY:-}"
SSH_PERMIT_ROOT_LOGIN="${SSH_PERMIT_ROOT_LOGIN:-no}"

SSHD_CONFIG="/etc/ssh/sshd_config"
AUTHORIZED_KEYS_DIR="/etc/ssh/authorized_keys"

echo "🔧 [setup-ssh] Iniciando configuração do SSH server..."

# -----------------------------------------------------------------------------
# Porta do SSH
# -----------------------------------------------------------------------------
if grep -q "^Port " "${SSHD_CONFIG}"; then
    sed -i "s/^Port .*/Port ${SSH_PORT}/" "${SSHD_CONFIG}"
else
    echo "Port ${SSH_PORT}" >> "${SSHD_CONFIG}"
fi
echo "   ↳ Porta configurada: ${SSH_PORT}"

# -----------------------------------------------------------------------------
# Login root (desativado por padrão)
# -----------------------------------------------------------------------------
if grep -q "^PermitRootLogin " "${SSHD_CONFIG}"; then
    sed -i "s/^PermitRootLogin .*/PermitRootLogin ${SSH_PERMIT_ROOT_LOGIN}/" "${SSHD_CONFIG}"
else
    echo "PermitRootLogin ${SSH_PERMIT_ROOT_LOGIN}" >> "${SSHD_CONFIG}"
fi

# -----------------------------------------------------------------------------
# Autenticação por senha (somente se SSH_PASSWORD estiver definido no .env)
# -----------------------------------------------------------------------------
if [ -n "${SSH_PASSWORD}" ]; then
    echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
    if grep -q "^PasswordAuthentication " "${SSHD_CONFIG}"; then
        sed -i "s/^PasswordAuthentication .*/PasswordAuthentication yes/" "${SSHD_CONFIG}"
    else
        echo "PasswordAuthentication yes" >> "${SSHD_CONFIG}"
    fi
    echo "   ↳ Autenticação por senha: ATIVADA (usuário ${SSH_USERNAME})"
else
    if grep -q "^PasswordAuthentication " "${SSHD_CONFIG}"; then
        sed -i "s/^PasswordAuthentication .*/PasswordAuthentication no/" "${SSHD_CONFIG}"
    else
        echo "PasswordAuthentication no" >> "${SSHD_CONFIG}"
    fi
    echo "   ↳ Autenticação por senha: DESATIVADA (SSH_PASSWORD não definido)"
fi

# -----------------------------------------------------------------------------
# Autenticação por chave pública — fora do $HOME de propósito (ver cabeçalho)
# -----------------------------------------------------------------------------
if grep -q "^AuthorizedKeysFile " "${SSHD_CONFIG}"; then
    sed -i "s|^AuthorizedKeysFile .*|AuthorizedKeysFile ${AUTHORIZED_KEYS_DIR}/%u|" "${SSHD_CONFIG}"
else
    echo "AuthorizedKeysFile ${AUTHORIZED_KEYS_DIR}/%u" >> "${SSHD_CONFIG}"
fi

if [ -n "${SSH_PUBLIC_KEY}" ]; then
    mkdir -p "${AUTHORIZED_KEYS_DIR}"
    echo "${SSH_PUBLIC_KEY}" > "${AUTHORIZED_KEYS_DIR}/${SSH_USERNAME}"
    chmod 755 "${AUTHORIZED_KEYS_DIR}"
    chmod 644 "${AUTHORIZED_KEYS_DIR}/${SSH_USERNAME}"
    chown root:root "${AUTHORIZED_KEYS_DIR}/${SSH_USERNAME}"
    echo "   ↳ Chave pública: ADICIONADA em ${AUTHORIZED_KEYS_DIR}/${SSH_USERNAME}"
    echo "     (fora do \$HOME — o ~/.ssh do container é o ~/.ssh do host montado por bind mount)"
fi

if [ -z "${SSH_PASSWORD}" ] && [ -z "${SSH_PUBLIC_KEY}" ]; then
    echo "⚠️  [setup-ssh] Nenhum SSH_PASSWORD ou SSH_PUBLIC_KEY definido no .env."
    echo "    O SSH será iniciado, mas ninguém conseguirá autenticar."
fi

# -----------------------------------------------------------------------------
# Chaves de host do sshd (gera apenas se ainda não existirem)
# -----------------------------------------------------------------------------
ssh-keygen -A

mkdir -p /var/run/sshd

echo "✅ [setup-ssh] SSH server configurado com sucesso na porta ${SSH_PORT}."