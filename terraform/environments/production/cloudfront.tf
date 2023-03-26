# configure cloudfront for TLS termination to our s3 static site
resource "aws_cloudfront_distribution" "www_s3_distribution" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.devsec0ps-static-site.website_endpoint
    origin_id   = "www.${aws_s3_bucket_website_configuration.devsec0ps-static-site.website_endpoint}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  # let's go ahead and use a much more modern cipher set, everything should support at least TLS 1.2 in 2023
  ## see: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/secure-connections-supported-viewer-protocols-ciphers.html
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.devsec0ps_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    target_origin_id           = aws_s3_bucket.devsec0ps-static-site.id
    allowed_methods            = ["GET"]
    cached_methods             = ["GET"]
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers_policy.id
    viewer_protocol_policy     = "redirect-to-https"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

}

# let's configure out default response header policy
resource "aws_cloudfront_response_headers_policy" "security_headers_policy" {
  name = "devsec0ps-headers-policy"
  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "DENY"
      override     = true
    }
    referrer_policy {
      referrer_policy = "same-origin"
      override        = true
    }
    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
    strict_transport_security {
      access_control_max_age_sec = "63072000"
      include_subdomains         = true
      preload                    = true
      override                   = true
    }
    content_security_policy {
      content_security_policy = "frame-ancestors 'none'; default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'"
      override                = true
    }
  }
}