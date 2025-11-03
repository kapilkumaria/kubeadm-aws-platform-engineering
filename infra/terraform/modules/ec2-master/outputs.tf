output "instance_id" {
  description = "Master EC2 Instance ID"
  value       = aws_instance.master.id
}

output "private_ip" {
  description = "Private IP of master node"
  value       = aws_instance.master.private_ip
}
