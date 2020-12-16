output "instance_id" {
  value       = join("", aws_instance.default.*.id)
  description = "Instance ID"
}

output "ssh_user" {
  value       = var.ssh_user
  description = "SSH user"
}

output "public_ip" {
  value       = join("", aws_instance.default.*.public_ip)
  description = "Public IP of the instance (or EIP)"
}

output "sg" {
  value       = element(aws_security_group.default.*.id, 0)
}
