#!/bin/bash
# =============================================================
# deploy.sh — Script de deploy da aplicação na EC2
# Executado via SSH pelo pipeline CI/CD ou manualmente
# =============================================================
set -euo pipefail

CONTAINER_NAME="devops-app"
APP_PORT="80"
CONTAINER_PORT="3000"
IMAGE_TAG="${IMAGE_TAG:-latest}"
ECR_URI="${ECR_URI:-}"

echo "================================================"
echo " DEPLOY — DevOps Fase 2 — PUCRS"
echo " Imagem: devops-fase2-app:${IMAGE_TAG}"
echo " $(date '+%d/%m/%Y %H:%M:%S')"
echo "================================================"

# Se tiver ECR configurado, faz pull; senão usa imagem local
if [ -n "${ECR_URI}" ]; then
  echo "[1/5] Autenticando no Amazon ECR..."
  aws ecr get-login-password --region us-east-1 | \
    docker login --username AWS --password-stdin "${ECR_URI}"

  echo "[2/5] Baixando nova imagem do ECR..."
  docker pull "${ECR_URI}/devops-fase2/app:${IMAGE_TAG}"
  FULL_IMAGE="${ECR_URI}/devops-fase2/app:${IMAGE_TAG}"
else
  echo "[1/5] Usando imagem local (sem ECR)..."
  FULL_IMAGE="devops-fase2-app:${IMAGE_TAG}"
  echo "[2/5] Build local da imagem..."
  docker build -t "${FULL_IMAGE}" ./app
fi

echo "[3/5] Parando container anterior (se existir)..."
docker stop "${CONTAINER_NAME}" 2>/dev/null || true
docker rm   "${CONTAINER_NAME}" 2>/dev/null || true

echo "[4/5] Iniciando nova versão..."
docker run -d \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  -p "${APP_PORT}:${CONTAINER_PORT}" \
  -e NODE_ENV=production \
  -e APP_VERSION="${IMAGE_TAG}" \
  "${FULL_IMAGE}"

echo "[5/5] Verificando saúde do container..."
sleep 5
for i in $(seq 1 5); do
  if curl -sf "http://localhost:${APP_PORT}/health" > /dev/null; then
    echo "✅ Deploy concluído com sucesso!"
    docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    exit 0
  fi
  echo "Aguardando... (${i}/5)"
  sleep 5
done

echo "❌ Falha no health check. Logs do container:"
docker logs --tail 30 "${CONTAINER_NAME}"
exit 1
