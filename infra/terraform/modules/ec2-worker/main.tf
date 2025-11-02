resource "aws_instance" "workers" {
  for_each = toset(var.subnet_ids)

  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = each.value
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids

  associate_public_ip_address = false

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-worker-${each.key}"
    }
  )
}
