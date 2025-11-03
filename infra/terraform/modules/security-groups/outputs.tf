output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "master_sg_id" {
  value = aws_security_group.master_sg.id
}

output "worker_sg_id" {
  value = aws_security_group.worker_sg.id
}
