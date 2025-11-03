# Bastion Host Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project}-${var.environment}-bastion-sg"
  description = "Security group for Bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH access to bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["205.206.76.190/32"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-bastion-sg"
    Environment = var.environment
    Project     = var.project
  }
}

# Master Node Security Group
resource "aws_security_group" "master_sg" {
  name        = "${var.project}-${var.environment}-master-sg"
  description = "Security group for Kubernetes master nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "Kube API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "etcd server client API"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-master-sg"
    Environment = var.environment
    Project     = var.project
  }
}

# Worker Node Security Group
resource "aws_security_group" "worker_sg" {
  name        = "${var.project}-${var.environment}-worker-sg"
  description = "Security group for Kubernetes worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "Allow traffic from Master"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    security_groups = [aws_security_group.master_sg.id]
  }

  ingress {
    description = "NodePort / Pod Communication"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-worker-sg"
    Environment = var.environment
    Project     = var.project
  }
}
