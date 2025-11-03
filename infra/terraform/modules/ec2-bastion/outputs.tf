output "public_ip" {
  description = "Public IP of Bastion"
  value       = aws_instance.bastion.public_ip
}

output "instance_id" {
  description = "Bastion EC2 Instance ID"
  value       = aws_instance.bastion.id
}

output "private_ip" {
  description = "Private IP of bastion instance"
  value       = aws_instance.bastion.private_ip
}

