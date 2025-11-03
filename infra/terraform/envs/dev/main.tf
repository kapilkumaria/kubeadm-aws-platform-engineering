# VPC Module
module "vpc" {
  source               = "../../modules/vpc"
  project              = "kubeadm-aws-platform"
  environment          = var.environment
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

# Worker 1
module "worker_1" {
  source                 = "../../modules/ec2-worker"
  project                = var.project
  environment            = var.environment
  ami_id                 = var.ami_id
  instance_type          = "t3.medium"
  subnet_id              = module.vpc.private_subnet_ids[0]
  vpc_security_group_ids = [module.security_groups.worker_sg_id]
  key_name               = var.key_name

  tags = {
    ManagedBy = "Terraform"
    Name      = "${var.project}-${var.environment}-worker-1"
  }
}

# Worker 2
module "worker_2" {
  source                 = "../../modules/ec2-worker"
  project                = var.project
  environment            = var.environment
  ami_id                 = var.ami_id
  instance_type          = "t3.medium"
  subnet_id              = module.vpc.private_subnet_ids[1]
  vpc_security_group_ids = [module.security_groups.worker_sg_id]
  key_name               = var.key_name

  tags = {
    ManagedBy = "Terraform"
    Name      = "${var.project}-${var.environment}-worker-2"
  }
}
