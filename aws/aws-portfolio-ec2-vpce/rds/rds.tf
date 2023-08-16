resource "aws_db_subnet_group" "aws-proj2-db-subnet-group" {

  name       = "aws-proj2-db-subnet-group"
  subnet_ids = [var.aws_rds_subnet_1, var.aws_rds_subnet_2]

  tags = {
    Name      = "aws-proj2-db-subnet-group"
    "Project" = "aws-proj2"
  }

}

resource "aws_db_instance" "aws-proj2-mssql-instance" {

  engine         = "sqlserver-ex"
  engine_version = "15.00"
  instance_class = "db.t3.small"

  allocated_storage = "20"
  storage_type      = "gp3"
  iops              = "3000"
  storage_encrypted = false

  # these are set to make the project easier to troubleshoot
  skip_final_snapshot = true
  apply_immediately   = true
  deletion_protection = false


  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.aws-proj2-db-subnet-group.name
  vpc_security_group_ids = [var.aws_security_group_id]
  publicly_accessible    = false

  username = "aws-proj2"
  password = "aws-proj2-TT-123!"

  tags = {
    Name    = "aws-proj2-mssql-instance"
    Project = "aws-proj2"
  }

}
