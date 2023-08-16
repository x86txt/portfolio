output "fqdn" {
  value = aws_instance.aws-proj2-windows-ec2-instance.public_dns
}

output "ip" {
  value = aws_instance.aws-proj2-windows-ec2-instance.public_ip
}
