module "vpc" {
  source               = "../../modules/vpc"
  project              = "kubeadm-aws-platform"
  environment          = var.environment                 # dev
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "bastion" {
  source               = "../../modules/ec2-bastion"
  vpc_id               = module.vpc.vpc_id
  public_subnet        = module.vpc.public_subnets[0]
  key_name             = var.key_name
  environment          = var.environment
  project              = var.project
}

module "k8s_master" {
  source               = "../../modules/ec2-master"
  private_subnet       = module.vpc.private_subnets[0]
  vpc_id               = module.vpc.vpc_id
  key_name             = var.key_name
  environment          = var.environment
  project              = var.project
}

module "k8s_workers" {
  source               = "../../modules/ec2-worker"
  private_subnets      = module.vpc.private_subnets
  vpc_id               = module.vpc.vpc_id
  key_name             = var.key_name
  environment          = var.environment
  project              = var.project
}
