# let's create an internal alb and listener to sit between our cloudfront distro and s3
# this is not necessary for this simple static site, but is being done to illustrate how to configure an alb

resource "aws_lb" "devsec0ps-internal" {
  name               = "devsec0ps-internal-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.devsec0ps-sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.devsec0ps-alb-logs.id
    prefix  = "test-lb"
    enabled = true
  }

}

