output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.devsec0ps-ninja.id
}

output "vpc_cidr" {
  value = aws_vpc.devsec0ps-ninja.cidr_block
}

output "vpc_public_subnets" {
  # Result is a map of subnet id to cidr block, e.g.
  # { "subnet_1234" => "10.0.1.0/4", ...}
  value = {
    for subnet in aws_subnet.public :
    subnet.id => subnet.cidr_block
  }
}

output "vpc_private_subnets" {
  # Result is a map of subnet id to cidr block, e.g.
  # { "subnet_1234" => "10.0.1.0/4", ...}
  value = {
    for subnet in aws_subnet.private :
    subnet.id => subnet.cidr_block
  }
}

# let's output the s3 internal fqdn for our new static site bucket
output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.devsec0ps-static-site.website_endpoint
}

# this is for our newly generated TLS cert
output "public_tls_cert" {
  value = aws_acm_certificate.devsec0ps_certificate.arn
}

# output our registrar assigned name servers for our domain
output "registrar_name_servers" {
  value = aws_route53_zone.devsec0ps_zone.name_servers
}
