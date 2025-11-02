output "master_private_ip" {
  value       = aws_instance.master.private_ip
  description = "Private IP of the Kubernetes Master"
}

output "master_id" {
  value       = aws_instance.master.id
  description = "Instance ID of master"
}
