resource "aws_instance" "aws-proj2-windows-ec2-instance" {

  ami                    = var.aws_ami
  instance_type          = "t3.micro"
  availability_zone      = "${var.aws_region}a"
  vpc_security_group_ids = [var.aws_security_group_id]
  user_data              = <<EOF
                            <powershell>
                                # enter full scripts here
                            </powershell>
                            EOF

  tags = {
    Name    = "aws-proj2-ec2-instance"
    Project = "aws-proj2"
  }

}
