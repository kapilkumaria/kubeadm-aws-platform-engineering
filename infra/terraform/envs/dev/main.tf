module "vpc" {
  source = "../../modules/vpc"

  environment          = var.environment                 # dev
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  aws_region           = var.aws_region
}
