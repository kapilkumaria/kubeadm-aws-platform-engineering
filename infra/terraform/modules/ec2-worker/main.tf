resource "aws_instance" "worker" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids

  associate_public_ip_address = false

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-worker"
    }
  )
}
