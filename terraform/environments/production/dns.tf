# let's make sure we've got our route 53 domain configured for dns and certificate management (ACM)
resource "aws_route53_zone" "devsec0ps_zone" {
  name          = var.root_domain_name
  force_destroy = true
}

resource "aws_route53_record" "devsec0ps_dns" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.devsec0ps_certificate.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.devsec0ps_certificate.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.devsec0ps_certificate.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.devsec0ps_zone.id
  ttl             = 60
}

# now we need to update the Route 53 registrar information with the assigned name servers
resource "aws_route53domains_registered_domain" "devsec0ps-domain" {
  domain_name = var.root_domain_name

  name_server {
    name = tolist(aws_route53_zone.devsec0ps_zone.name_servers)[0]
  }

  name_server {
    name = tolist(aws_route53_zone.devsec0ps_zone.name_servers)[1]
  }

  name_server {
    name = tolist(aws_route53_zone.devsec0ps_zone.name_servers)[2]
  }

  name_server {
    name = tolist(aws_route53_zone.devsec0ps_zone.name_servers)[3]
  }

}
