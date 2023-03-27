# let's create our main vpc for the project
resource "aws_vpc" "devsec0ps-ninja" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "devsec0ps.ninja"
  }
}

# let's add our public and private subnets, 1 subnet per availability zone for HA and redundancy
resource "aws_subnet" "public" {
  for_each = var.public_subnet_numbers

  vpc_id            = aws_vpc.devsec0ps-ninja.id
  availability_zone = each.key

  # 2,048 IP addresses each
  cidr_block = cidrsubnet(aws_vpc.devsec0ps-ninja.cidr_block, 4, each.value)

  tags = {
    Name      = "devsec0ps-ninja-public-subnet"
    Project   = "devsec0ps.ninja"
    Role      = "public"
    ManagedBy = "terraform"
    Subnet    = "${each.key}-${each.value}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnet_numbers

  vpc_id            = aws_vpc.devsec0ps-ninja.id
  availability_zone = each.key

  # 2,048 IP addresses each
  cidr_block = cidrsubnet(aws_vpc.devsec0ps-ninja.cidr_block, 4, each.value)

  tags = {
    Name      = "devsec0ps-ninja-private-subnet"
    Project   = "devsec0ps.ninja"
    Role      = "private"
    ManagedBy = "terraform"
    Subnet    = "${each.key}-${each.value}"
  }
}
