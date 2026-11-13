#!/usr/bin/env bash
# =============================================================================
# setup-dev-certs.sh
# Configura o certificado HTTPS de desenvolvimento usando apenas `dotnet dev-certs`.
# Executar como o usuário de desenvolvimento (ex.: ubuntu), NÃO como root.
# Uso: bash setup-dev-certs.sh
# =============================================================================
set -uo pipefail

log()  { echo "🔐 $*"; }
warn() { echo "⚠️  $*" >&2; }

if [ "$(id -u)" -eq 0 ]; then
    warn "Rode como usuário comum (ex.: ubuntu). O trust do dotnet é por usuário."
    exit 1
fi

EXPORT_DIR="${DEV_CERT_EXPORT_DIR:-$HOME/.aspnet/dev-certs/export}"
TRUST_DIR="$HOME/.aspnet/dev-certs/trust"
SYSTEM_CA_DIR="/usr/local/share/ca-certificates"

# -----------------------------------------------------------------------------
# 1) Dependências necessárias para o --trust no Linux (openssl + certutil)
# -----------------------------------------------------------------------------
missing=()
command -v openssl  >/dev/null 2>&1 || missing+=("openssl")
command -v certutil >/dev/null 2>&1 || missing+=("libnss3-tools")

if [ "${#missing[@]}" -gt 0 ]; then
    log "Instalando dependências: ${missing[*]}"
    if command -v sudo >/dev/null 2>&1; then
        sudo apt-get update -qq \
            && sudo apt-get install -y --no-install-recommends "${missing[@]}" >/dev/null \
            || warn "Não foi possível instalar: ${missing[*]}"
    else
        warn "sudo indisponível. Instale manualmente: ${missing[*]}"
    fi
fi

# -----------------------------------------------------------------------------
# 2) SSL_CERT_DIR (necessário para o .NET enxergar o certificado confiado)
# -----------------------------------------------------------------------------
SSL_LINE="export SSL_CERT_DIR=\"$TRUST_DIR:/usr/lib/ssl/certs\""
export SSL_CERT_DIR="$TRUST_DIR:/usr/lib/ssl/certs"
mkdir -p "$TRUST_DIR"

for rc in "$HOME/.bashrc" "$HOME/.profile"; do
    touch "$rc"
    grep -qxF "$SSL_LINE" "$rc" || echo "$SSL_LINE" >> "$rc"
done

# -----------------------------------------------------------------------------
# 3) Gera o certificado (limpa e recria se não estiver válido)
# -----------------------------------------------------------------------------
if ! dotnet dev-certs https --check >/dev/null 2>&1; then
    log "Gerando novo certificado de desenvolvimento..."
    dotnet dev-certs https --clean >/dev/null 2>&1 || true
    dotnet dev-certs https >/dev/null 2>&1 || { warn "Falha ao gerar o certificado."; exit 1; }
fi

# -----------------------------------------------------------------------------
# 4) Trust do usuário (OpenSSL + NSS)
# -----------------------------------------------------------------------------
log "Confiando no certificado para o usuário $(id -un)..."
dotnet dev-certs https --trust
trust_rc=$?

if [ "$trust_rc" -ne 0 ]; then
    warn "dotnet dev-certs --trust retornou código $trust_rc (trust parcial)."
fi

# -----------------------------------------------------------------------------
# 5) Exporta o certificado e instala no repositório de CAs do sistema
# -----------------------------------------------------------------------------
mkdir -p "$EXPORT_DIR"
dotnet dev-certs https -ep "$EXPORT_DIR/aspnetapp.crt" --format Pem --no-password >/dev/null 2>&1 \
    && chmod 644 "$EXPORT_DIR/aspnetapp.crt" \
    && log "Certificado exportado em $EXPORT_DIR/aspnetapp.crt"

if [ -f "$EXPORT_DIR/aspnetapp.crt" ] && command -v sudo >/dev/null 2>&1; then
    sudo cp "$EXPORT_DIR/aspnetapp.crt" "$SYSTEM_CA_DIR/aspnetapp-dev.crt" \
        && sudo update-ca-certificates >/dev/null 2>&1 \
        && log "Certificado instalado no sistema (todos os usuários)."
fi

# -----------------------------------------------------------------------------
# 6) Verificação final
# -----------------------------------------------------------------------------
if dotnet dev-certs https --check --trust >/dev/null 2>&1; then
    log "Certificado válido e confiado. ✅"
else
    warn "Trust parcial: o certificado funciona no sistema (curl/.NET), mas"
    warn "navegadores podem exigir importar $EXPORT_DIR/aspnetapp.crt manualmente."
fi

exit 0