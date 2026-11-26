#!/bin/bash
# =============================================================================
# setup-dev-certs.sh
# Configuração HTTPS do .NET e certificados TLS do Redis/Aspire.
# Executar como usuário comum (ex.: ubuntu), NÃO como root.
# =============================================================================

set -euo pipefail

log()  { echo "🔐 $*"; }
warn() { echo "⚠️  $*" >&2; }

if [ "$(id -u)" -eq 0 ]; then
    warn "Execute como usuário comum, não como root."
    exit 1
fi

EXPORT_DIR="${DEV_CERT_EXPORT_DIR:-$HOME/.aspnet/dev-certs/export}"
TRUST_DIR="$HOME/.aspnet/dev-certs/trust"

ASPIRE_DIR="/usr/lib/ssl/aspire"
PRIVATE_DIR="$ASPIRE_DIR/private"

SYSTEM_CA_DIR="/usr/local/share/ca-certificates"

# Identidade do certificado Redis
REDIS_CERT_NAME="redis"
REDIS_CERT="$PRIVATE_DIR/${REDIS_CERT_NAME}.crt"
REDIS_KEY="$PRIVATE_DIR/${REDIS_CERT_NAME}.key"
REDIS_CA="$ASPIRE_DIR/cert.pem"

# =============================================================================
# 1. Dependências
# =============================================================================

missing=()

for cmd in openssl certutil dotnet; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
done

if [ "${#missing[@]}" -gt 0 ]; then
    log "Instalando dependências..."

    sudo apt-get update -qq
    sudo apt-get install -y \
        openssl \
        libnss3-tools \
        ca-certificates
fi

# =============================================================================
# 2. SSL_CERT_DIR
# =============================================================================

mkdir -p "$TRUST_DIR"

SSL_LINE="export SSL_CERT_DIR=\"$TRUST_DIR:/usr/lib/ssl/certs\""

export SSL_CERT_DIR="$TRUST_DIR:/usr/lib/ssl/certs"

for rc in "$HOME/.bashrc" "$HOME/.profile"; do
    touch "$rc"
    grep -qxF "$SSL_LINE" "$rc" || echo "$SSL_LINE" >> "$rc"
done

# =============================================================================
# 3. Certificado HTTPS do .NET
# =============================================================================

if ! dotnet dev-certs https --check >/dev/null 2>&1; then
    log "Gerando certificado HTTPS do .NET..."

    dotnet dev-certs https >/dev/null
fi

log "Configurando trust do .NET..."

dotnet dev-certs https --trust || \
    warn "Trust do usuário apresentou alguma restrição."

# =============================================================================
# 4. Exportação do certificado HTTPS
# =============================================================================

mkdir -p "$EXPORT_DIR"

dotnet dev-certs https \
    -ep "$EXPORT_DIR/aspnetapp.crt" \
    --format Pem \
    --no-password

chmod 644 "$EXPORT_DIR/aspnetapp.crt"

if command -v sudo >/dev/null 2>&1; then
    sudo cp "$EXPORT_DIR/aspnetapp.crt" \
        "$SYSTEM_CA_DIR/aspnetapp-dev.crt"

    sudo update-ca-certificates
fi

# =============================================================================
# 5. Diretórios TLS do Aspire
# =============================================================================

log "Preparando diretórios TLS do Aspire..."

sudo install -d -m 755 "$ASPIRE_DIR"
sudo install -d -m 700 "$PRIVATE_DIR"

# =============================================================================
# 6. CA própria para Redis
# =============================================================================

if [ ! -f "$ASPIRE_DIR/redis-ca.key" ] || \
   [ ! -f "$REDIS_CA" ]; then

    log "Gerando CA privada para Redis..."

    TMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TMP_DIR"' EXIT

    openssl genrsa \
        -out "$TMP_DIR/ca.key" 4096

    openssl req -x509 -new \
        -key "$TMP_DIR/ca.key" \
        -sha256 \
        -days 3650 \
        -subj "/CN=Aspire Redis Development CA" \
        -out "$TMP_DIR/cert.pem"

    sudo install -m 600 \
        "$TMP_DIR/ca.key" \
        "$ASPIRE_DIR/redis-ca.key"

    sudo install -m 644 \
        "$TMP_DIR/cert.pem" \
        "$REDIS_CA"
fi

# =============================================================================
# 7. Certificado TLS do Redis
# =============================================================================

if [ ! -f "$REDIS_CERT" ] || [ ! -f "$REDIS_KEY" ]; then

    log "Gerando certificado TLS do Redis..."

    TMP_DIR="$(mktemp -d)"

    openssl genrsa \
        -out "$TMP_DIR/redis.key" 2048

    openssl req -new \
        -key "$TMP_DIR/redis.key" \
        -subj "/CN=redis" \
        -out "$TMP_DIR/redis.csr"

    cat > "$TMP_DIR/extensions.cnf" <<'EOF'
subjectAltName=DNS:redis,DNS:redis-cache,DNS:localhost,IP:127.0.0.1
extendedKeyUsage=serverAuth
keyUsage=digitalSignature,keyEncipherment
EOF

    sudo openssl x509 -req \
        -in "$TMP_DIR/redis.csr" \
        -CA "$REDIS_CA" \
        -CAkey "$ASPIRE_DIR/redis-ca.key" \
        -CAcreateserial \
        -out "$TMP_DIR/redis.crt" \
        -days 825 \
        -sha256 \
        -extfile "$TMP_DIR/extensions.cnf"

    sudo install -m 644 \
        "$TMP_DIR/redis.crt" "$REDIS_CERT"

    sudo install -m 600 \
        "$TMP_DIR/redis.key" "$REDIS_KEY"

    rm -rf "$TMP_DIR"
fi

# =============================================================================
# 8. Verificação
# =============================================================================

log "Validando certificados..."

sudo openssl verify \
    -CAfile "$REDIS_CA" \
    "$REDIS_CERT"

openssl x509 \
    -in "$REDIS_CA" \
    -noout -subject -dates

log "Certificados configurados."

echo
echo "CA:          $REDIS_CA"
echo "Certificado: $REDIS_CERT"
echo "Chave:       $REDIS_KEY"
echo
log "Configuração concluída."