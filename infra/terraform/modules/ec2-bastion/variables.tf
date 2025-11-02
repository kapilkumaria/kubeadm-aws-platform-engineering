variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Bastion Host"
  type        = string
}

variable "instance_type" {
  description = "Instance type for Bastion"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID where Bastion will be deployed (Public Subnet)"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
}

variable "key_name" {
  description = "Key pair name to SSH into Bastion"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
