#!/bin/bash
# =============================================================
# rollback.sh — Reversão para versão anterior
# Uso: ./rollback.sh <tag-da-versao-anterior>
# =============================================================
set -euo pipefail

ROLLBACK_TAG="${1:-}"

if [ -z "${ROLLBACK_TAG}" ]; then
  echo "❌ Erro: informe a tag para rollback"
  echo "Uso: ./rollback.sh <tag>"
  echo ""
  echo "Containers em execução:"
  docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
  exit 1
fi

echo "⚠️  Iniciando rollback para versão: ${ROLLBACK_TAG}"
IMAGE_TAG="${ROLLBACK_TAG}" bash "$(dirname "$0")/deploy.sh"
echo "✅ Rollback concluído para: ${ROLLBACK_TAG}"
