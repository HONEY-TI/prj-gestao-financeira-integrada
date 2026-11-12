#!/bin/bash
# gencert-private
# Gera webapi-cert.pfx por padrão, caso nenhum nome seja informado.
# Uso: ./gencert-private [nome-base] [senha]

set -e

arquivo_base="${1:-webapi-cert}"
senha="${2:-12345!}"

chave_privada="${arquivo_base}_chave.pem"
certificado="${arquivo_base}_cert.pem"
arquivo_pfx="${arquivo_base}.pfx"

# 🔑 Chave privada (sem prompt de senha)
if [ ! -f "$chave_privada" ]; then
    echo "🔑 Gerando chave privada RSA..."
    openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "$chave_privada"
fi

# 📜 Certificado autoassinado com SAN (sem perguntas interativas)
if [ ! -f "$certificado" ]; then
    echo "📜 Gerando certificado autoassinado..."
    openssl req -x509 -new -key "$chave_privada" \
        -out "$certificado" -days 365 \
        -subj "/CN=localhost" \
        -addext "subjectAltName=DNS:localhost,DNS:*.dev.localhost,IP:127.0.0.1"
fi

# 📦 PFX protegido por senha
echo "📦 Gerando arquivo PFX..."
openssl pkcs12 -export -out "$arquivo_pfx" \
    -inkey "$chave_privada" -in "$certificado" \
    -passout "pass:${senha}"

echo "✅ Concluído: $arquivo_pfx"