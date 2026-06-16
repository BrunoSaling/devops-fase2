variable "aws_region" {
  default = "us-east-1"
}

variable "nome_projeto" {
  default = "devops-fase2"
}

variable "ambiente" {
  default = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.ambiente)
    error_message = "Ambiente deve ser dev, staging ou prod."
  }
}

variable "turma" {
  default = "DevOps-2024"
}

variable "cidr_vpc" {
  default = "10.0.0.0/16"
}

variable "subnets_publicas" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "subnets_privadas" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "tipo_instancia" {
  default = "t2.micro"
}

variable "chave_ssh" {
  default = "devops-key"
}