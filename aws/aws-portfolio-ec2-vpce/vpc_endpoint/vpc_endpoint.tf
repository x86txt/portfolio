resource "aws_lb" "aws-proj2-lb" {

  name                       = "aws-proj2-lb"
  internal                   = true
  subnets                    = [var.aws_alb_subnet_1, var.aws_alb_subnet_2]
  load_balancer_type         = "network"
  enable_deletion_protection = false

  tags = {
    Name    = "aws-proj2-lb"
    Project = "aws-proj2"
  }

}

resource "aws_lb_listener" "aws-proj2-lb-listener" {

  for_each = var.ports

  load_balancer_arn = aws_lb.aws-proj2-lb.arn
  protocol          = "TCP"
  port              = each.value

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws-proj2-tg[each.key].arn
  }

  tags = {
    Name    = "aws-proj2-alb-listener-${each.key}"
    Project = "aws-proj2"
  }

}

resource "aws_lb_target_group" "aws-proj2-tg" {

  name     = "aws-proj2-tg-port-${each.key}"
  for_each = var.ports

  target_type = "instance"
  port        = each.value
  protocol    = "TCP"
  vpc_id      = var.aws_vpc

  depends_on = [
    aws_lb.aws-proj2-lb
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "aws-proj2-tg-port-${each.key}"
    Project = "aws-proj2"
  }

}

resource "aws_vpc_endpoint_service" "aws-proj2-vpce" {

  network_load_balancer_arns = [aws_lb.aws-proj2-lb.arn]

  allowed_principals  = var.vpce_allowed_principals
  acceptance_required = false

  tags = {
    Name    = "aws-proj2-vpce"
    Project = "aws-proj2"
  }

}
