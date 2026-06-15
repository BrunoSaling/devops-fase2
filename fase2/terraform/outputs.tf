output "vpc_id"              { value = module.vpc.vpc_id }
output "subnets_publicas"    { value = module.vpc.subnet_publica_ids }
output "ec2_ip_publico"      { value = module.ec2_app.ip_publico }
output "ec2_id"              { value = module.ec2_app.instance_id }
output "s3_bucket_artefatos" { value = module.s3_artefatos.bucket_name }
