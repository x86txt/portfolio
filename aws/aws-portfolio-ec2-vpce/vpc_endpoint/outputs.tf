output "alb_name" {
  value = aws_lb.aws-proj2-lb.dns_name
}

output "service_name" {
  value = aws_vpc_endpoint_service.aws-proj2-vpce.service_name
}
