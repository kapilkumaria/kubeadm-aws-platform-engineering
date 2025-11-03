output "private_ip" {
  description = "Private IP of worker node"
  value       = aws_instance.worker.private_ip
}

output "instance_id" {
  description = "Instance ID of this worker node"
  value       = aws_instance.worker.id
}
