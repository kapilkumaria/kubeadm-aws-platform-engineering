# VPC Module
module "vpc" {
  source               = "../../modules/vpc"
  project              = "kubeadm-aws-platform"
  environment          = var.environment                 # prod
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# Security Groups Module
module "security_groups" {
  source      = "../../modules/security-groups"
  project     = var.project
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

# Bastion module
module "bastion" {
  source                 = "../../modules/ec2-bastion"
  project                = var.project
  environment            = var.environment
  ami_id                 = var.ami_id 
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [module.security_groups.bastion_sg_id]
  key_name               = var.key_name

  tags = {
    ManagedBy = "Terraform"
  }
}

# EC2 Master Module
module "master" {
  source                 = "../../modules/ec2-master"
  project                = var.project
  environment            = var.environment
  ami_id                 = var.ami_id 
  instance_type          = "t3.medium"
  subnet_id              = module.vpc.private_subnet_ids[0]
  vpc_security_group_ids = [module.security_groups.master_sg_id]
  key_name               = var.key_name   
}

# EC2 Worker Module
module "workers" {
  source                 = "../../modules/ec2-worker"
  project                = var.project
  environment            = var.environment
  ami_id                 = var.ami_id
  instance_type          = "t3.medium"
  subnet_ids             = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.security_groups.worker_sg_id]
  key_name               = var.key_name
}