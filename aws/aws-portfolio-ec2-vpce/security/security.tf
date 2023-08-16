resource "aws_security_group" "aws-proj2-alb-sg" {

  name        = "alb security group"
  description = "alb security group"
  vpc_id      = var.aws_vpc

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

  ingress {
    from_port = 7000
    to_port   = 7010
    protocol  = "tcp"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name"    = "aws-proj2-alb-sg"
    "Project" = "aws-proj2"
  }

}

resource "aws_security_group" "aws-proj2-ec2-sg" {

  name        = "ec2 security group"
  description = "ec2 security group"
  vpc_id      = var.aws_vpc

  ingress {
    from_port       = "443"
    to_port         = "443"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.aws-proj2-alb-sg.id}"]
  }

  ingress {
    from_port       = "7000"
    to_port         = "7010"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.aws-proj2-alb-sg.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.aws-proj2-alb-sg.id}"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name"    = "aws-proj2-ec2-sg"
    "Project" = "aws-proj2"
  }

}

resource "aws_security_group" "aws-proj2-rds-sg" {

  name        = "rds security group"
  description = "rds security group"
  vpc_id      = var.aws_vpc

  ingress {
    from_port       = "1433"
    to_port         = "1433"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.aws-proj2-ec2-sg.id}"]
  }

  egress {
    from_port       = "1433"
    to_port         = "1433"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.aws-proj2-ec2-sg.id}"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name"    = "aws-proj2-rds-sg"
    "Project" = "aws-proj2"
  }

}
