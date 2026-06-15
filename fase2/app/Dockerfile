# ─────────────────────────────────────────────────────────────
# Dockerfile — Aplicação DevOps Fase 2 — PUCRS
# ─────────────────────────────────────────────────────────────

# Imagem base: Node.js 20 LTS em Alpine Linux (leve e segura ~180MB)
FROM node:20-alpine

# Metadados da imagem
LABEL maintainer="devops@pucrs.br"
LABEL version="1.0.0"
LABEL description="API DevOps Fase 2 — PUCRS AWS Academy"

# Diretório de trabalho dentro do container
WORKDIR /app

# Copiar manifests ANTES do código (aproveita cache de camadas do Docker)
COPY package*.json ./

# Instalar somente dependências de produção
RUN npm install --only=production && npm cache clean --force

# Copiar o restante do código-fonte
COPY . .

# Criar usuário não-root para executar a aplicação (boa prática de segurança)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Variáveis de ambiente padrão
ENV NODE_ENV=production
ENV PORT=3000

# Porta exposta pelo container
EXPOSE 3000

# Verificação de saúde a cada 30 segundos
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

# Comando de inicialização (exec form para receber sinais do SO corretamente)
CMD ["node", "server.js"]
