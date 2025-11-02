resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id

  vpc_security_group_ids = var.vpc_security_group_ids
  key_name                    = var.key_name

  associate_public_ip_address = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-bastion"
    }
  )
}
