#!/bin/bash
set -euo pipefail
exec > >(tee /var/log/user-data.log | logger -t user-data) 2>&1
echo "=============================="
echo " Provisionamento EC2 — Fase 2"
echo " $(date)"
echo "=============================="
dnf update -y
dnf install -y git curl wget unzip
# Docker
dnf install -y docker
systemctl enable docker && systemctl start docker
usermod -aG docker ec2-user
# Docker Compose
curl -SL https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-linux-x86_64 \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip && ./aws/install && rm -rf awscliv2.zip aws/
echo "Docker: $(docker --version)"
echo "Compose: $(docker-compose --version)"
echo "Provisionamento concluído! $(date)"
