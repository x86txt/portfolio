# create several security groups, allow inbound only from cloudfront, but all outbound for our new vpc
## see: https://stackoverflow.com/questions/69565387/terraform-automatically-create-sgs-for-cloudfront-ips
resource "aws_security_group" "devsec0ps-sg" {
  vpc_id = aws_vpc.devsec0ps-ninja.id

  count = length(local.chunks_v4)

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.chunks_v4[count.index]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
