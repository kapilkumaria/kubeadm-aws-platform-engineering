variable "project" { 
  type = string 
}

variable "environment" {
  type = string 
}

variable "ami_id" {
  type = string 
}

variable "instance_type" { 
  type = string 
  default = "t3.medium" 
}

variable "subnet_id" {
  description = "Subnet where worker EC2 will be launched"
  type        = string
}

variable "vpc_security_group_ids" {
  type = list(string) 
}

variable "key_name" { 
  type = string 
}

variable "tags" {
  type    = map(string)
  default = {}
}
