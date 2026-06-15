terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  backend "s3" {
    bucket  = "devops-projeto-tfstate"
    key     = "fase2/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
provider "aws" {
  region = var.aws_region
  default_tags { tags = { Projeto = "DevOps-Fase2", Ambiente = var.ambiente, Gerenciado = "Terraform", Turma = var.turma } }
}
data "aws_availability_zones" "available" { state = "available" }
data "aws_ami" "amazon_linux" {
  most_recent = true; owners = ["amazon"]
  filter { name = "name";                values = ["al2023-ami-*-x86_64"] }
  filter { name = "virtualization-type"; values = ["hvm"] }
}
module "vpc" {
  source = "./modules/vpc"
  nome_projeto = var.nome_projeto; ambiente = var.ambiente; cidr_vpc = var.cidr_vpc
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
  subnets_publicas = var.subnets_publicas; subnets_privadas = var.subnets_privadas
}
module "security_groups" {
  source = "./modules/security_groups"
  nome_projeto = var.nome_projeto; ambiente = var.ambiente; vpc_id = module.vpc.vpc_id
}
module "ec2_app" {
  source = "./modules/ec2"
  nome_projeto = var.nome_projeto; ambiente = var.ambiente; ami_id = data.aws_ami.amazon_linux.id
  tipo_instancia = var.tipo_instancia; subnet_id = module.vpc.subnet_publica_ids[0]
  sg_ids = [module.security_groups.sg_app_id]; chave_ssh = var.chave_ssh
  user_data = file("${path.module}/scripts/user_data.sh")
}
module "s3_artefatos" {
  source = "./modules/s3"
  nome_projeto = var.nome_projeto; ambiente = var.ambiente
  bucket_name = "${var.nome_projeto}-artefatos-${var.ambiente}"
}
