# DevOps Fase 2 — PUCRS

Repositório da Fase 2 do projeto DevOps: Entrega Contínua, Containers e Orquestração.

## Estrutura

```
├── .github/workflows/ci-cd.yml  # Pipeline CI/CD
├── app/                          # Aplicação Node.js
│   ├── server.js
│   ├── package.json
│   ├── Dockerfile
│   └── .dockerignore
├── terraform/                    # Infraestrutura como Código
├── nginx/nginx.conf              # Reverse proxy
├── docker-compose.yml            # Orquestração local
└── scripts/
    ├── deploy.sh                 # Deploy automatizado
    └── rollback.sh               # Rollback
```

## Como executar localmente

```bash
# Build e subir todos os containers
docker compose up -d --build

# Testar
curl http://localhost:80/health

# Derrubar
docker compose down
```

## Infraestrutura AWS

```bash
cd terraform
terraform init
terraform plan
terraform apply   # confirmar com yes
terraform destroy # ao finalizar os testes
```
