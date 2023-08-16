variable "aws_region" {
}

variable "aws_vpc" {
}

variable "aws_alb_subnet_1" {
}

variable "aws_alb_subnet_2" {
}

variable "instance_count" {
  default = 3
}

# variable "name" {
# }

variable "ports" {
  type = map(number)
  default = {
    http   = 80
    https  = 443
    cust0  = 7000
    cust1  = 7001
    cust2  = 7002
    cust3  = 7003
    cust4  = 7004
    cust5  = 7005
    cust6  = 7006
    cust7  = 7007
    cust8  = 7008
    cust9  = 7009
    cust10 = 7010

  }
}

variable "vpce_allowed_principals" {
  type    = list(string)
  default = ["*"]
}
