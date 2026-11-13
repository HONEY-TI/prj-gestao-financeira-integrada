#!/usr/bin/env bash
# aspire-clean.sh
# Limpa o lock órfão e o bundle parcial do Aspire CLI para que a próxima
# execução de `aspire run` extraia tudo de novo.
#
# Uso:
#   ./aspire-clean.sh              # pede confirmação antes de apagar
#   ./aspire-clean.sh -y           # sem confirmação
#   ./aspire-clean.sh -y --run     # limpa e já roda `aspire run`
#
# Variáveis opcionais:
#   ASPIRE_STORE=/caminho/.store/aspire.cli   (padrão: /usr/local/bin/.store/aspire.cli)

set -euo pipefail

STORE="${ASPIRE_STORE:-/usr/local/bin/.store/aspire.cli}"
ASSUME_YES=false
RUN_AFTER=false

for arg in "$@"; do
  case "$arg" in
    -y|--yes) ASSUME_YES=true ;;
    --run)    RUN_AFTER=true ;;
    -h|--help)
      sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Opção desconhecida: $arg" >&2; exit 1 ;;
  esac
done

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*"; }
err()  { printf '\033[1;31mxx\033[0m  %s\n' "$*" >&2; }

# Usa sudo só quando necessário
SUDO=""
if [[ $EUID -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  else
    warn "sudo não encontrado; operações em $STORE podem falhar por permissão."
  fi
fi

if [[ ! -d "$STORE" ]]; then
  err "Diretório não encontrado: $STORE"
  err "Ajuste com: ASPIRE_STORE=/caminho/correto $0"
  exit 1
fi

# 1) Processos aspire em execução (-x = nome exato, não casa com este script)
info "Verificando processos 'aspire' em execução..."
if pgrep -x aspire >/dev/null 2>&1; then
  warn "Processos aspire encontrados:"
  pgrep -a -x aspire || true
  pkill -x aspire || true
  sleep 2
  if pgrep -x aspire >/dev/null 2>&1; then
    warn "Ainda ativos; enviando SIGKILL."
    pkill -9 -x aspire || true
  fi
else
  info "Nenhum processo aspire rodando."
fi

# 2) Localiza locks e pastas 'tools' (bundle extraído)
mapfile -t LOCKS < <(find "$STORE" -name '.aspire-bundle-lock' 2>/dev/null || true)
mapfile -t TOOLS < <(find "$STORE" -mindepth 4 -maxdepth 4 -type d -name tools 2>/dev/null || true)

if [[ ${#LOCKS[@]} -eq 0 && ${#TOOLS[@]} -eq 0 ]]; then
  info "Nada para limpar em $STORE."
else
  info "Encontrado para limpeza:"
  for f in "${LOCKS[@]}"; do echo "   lock : $f"; done
  for d in "${TOOLS[@]}"; do echo "   bundle: $d"; done

  # 3) Verifica se alguém ainda segura algum lock
  if command -v lsof >/dev/null 2>&1; then
    for f in "${LOCKS[@]}"; do
      if $SUDO lsof "$f" >/dev/null 2>&1; then
        warn "Lock em uso por outro processo:"
        $SUDO lsof "$f" || true
        err "Encerre esse processo antes de limpar."
        exit 1
      fi
    done
  else
    warn "lsof não instalado; pulando verificação de lock em uso."
  fi

  # 4) Remove locks e bundles parciais
  for f in "${LOCKS[@]}"; do $SUDO rm -f "$f"; done
  for d in "${TOOLS[@]}"; do $SUDO rm -rf "$d"; done
  info "Lock e bundle removidos."
fi

# 5) Ajusta o dono para o usuário atual (evita falha de permissão na re-extração)
OWNER="${SUDO_USER:-$(id -un)}"
info "Ajustando dono de $STORE para $OWNER..."
$SUDO chown -R "$OWNER":"$(id -gn "$OWNER")" "$STORE"

info "Pronto. Rode 'aspire run' e não interrompa a primeira execução (Ctrl+C)."

# 6) Opcional: roda aspire em seguida
if [[ "$RUN_AFTER" == true ]]; then
  if ! command -v aspire >/dev/null 2>&1; then
    err "Comando 'aspire' não encontrado no PATH."
    exit 1
  fi
  info "Executando 'aspire run'..."
  exec aspire run
fi