output "ec2_alb_id" {
  value = aws_security_group.aws-proj2-alb-sg.id
}

output "ec2_sg_id" {
  value = aws_security_group.aws-proj2-ec2-sg.id
}

output "rds_sg_id" {
  value = aws_security_group.aws-proj2-rds-sg.id
}
