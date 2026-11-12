#!/usr/bin/env bash
# =============================================================================
# setup-dev-certs.sh
# Cria e confia no certificado HTTPS de desenvolvimento via Aspire CLI.
# Executar como o usuário de desenvolvimento (ex.: ubuntu), NÃO como root.
# =============================================================================
set -uo pipefail

[ "$(id -u)" -eq 0 ] && { echo "⚠️  Rode como usuário comum (ubuntu)." >&2; exit 1; }

TRUST_DIR="$HOME/.aspnet/dev-certs/trust"
export SSL_CERT_DIR="$TRUST_DIR:/usr/lib/ssl/certs"
mkdir -p "$TRUST_DIR" "$HOME/.pki/nssdb"

echo "🔐 Confiando no certificado de desenvolvimento..."
if command -v aspire >/dev/null 2>&1; then
    aspire certs trust || echo "⚠️  Trust parcial (código $?)." >&2
    aspire doctor 2>&1 | grep -i -A2 "dev-certs" || true
else
    echo "ℹ️  aspire não encontrado, usando dotnet dev-certs."
    dotnet dev-certs https --trust || echo "⚠️  Trust parcial (código $?)." >&2
fi