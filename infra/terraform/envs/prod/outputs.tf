# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# Bastion Host
output "bastion_public_ip" {
  description = "Bastion Public IP"
  value       = module.bastion.public_ip
}


# Master Node
output "master_private_ip" {
  description = "Master Private IP"
  value       = module.master.private_ip
}


# Worker Nodes
output "worker_private_ips" {
  value = [
    module.worker_1.private_ip,
    module.worker_2.private_ip
  ]
}

output "worker_instance_ids" {
  value = [
    module.worker_1.instance_id,
    module.worker_2.instance_id
  ]
}
