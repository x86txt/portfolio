# use acm to create a public TLS certificate, using DNS validation
## note: It's recommended to specify create_before_destroy = true in a lifecycle block to replace a certificate which is currently in use (eg, by aws_lb_listener).
resource "aws_acm_certificate" "devsec0ps_certificate" {
  domain_name       = "*.${var.root_domain_name}"

  subject_alternative_names = [
    "*.${var.root_domain_name}",
    var.root_domain_name
  ]

  validation_method = "DNS"
  
  lifecycle {
    create_before_destroy = true
  }
}

# validate our cert
resource "aws_acm_certificate_validation" "devsec0ps_validate" {
  certificate_arn         = aws_acm_certificate.devsec0ps_certificate.arn
  validation_record_fqdns = [aws_route53_record.devsec0ps_dns.fqdn]

  timeouts {
    create = "5m"
  }
}

