output "worker_private_ips" {
  value       = [for w in aws_instance.workers : w.private_ip]
  description = "Private IPs of all workers"
}
