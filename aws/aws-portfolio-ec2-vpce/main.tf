terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.11.0"
    }
  }

}

provider "aws" {
  region = var.aws_region
}

module "application" {

  source                = "./application"
  aws_region            = var.aws_region
  aws_vpc               = var.aws_vpc
  aws_ec2_subnet        = var.aws_ec2_subnet
  aws_security_group_id = module.security.ec2_sg_id
  aws_ami               = var.aws_ami

}

module "security" {

  source  = "./security"
  aws_vpc = var.aws_vpc

}

module "rds" {

  source                = "./rds"
  aws_region            = var.aws_region
  aws_security_group_id = module.security.rds_sg_id
  aws_vpc               = var.aws_vpc
  aws_rds_subnet_1      = var.aws_rds_subnet_1
  aws_rds_subnet_2      = var.aws_rds_subnet_2

}

module "vpc_endpoint" {

  source           = "./vpc_endpoint"
  aws_region       = var.aws_region
  aws_vpc          = var.aws_vpc
  aws_alb_subnet_1 = var.aws_alb_subnet_1
  aws_alb_subnet_2 = var.aws_alb_subnet_2
  
}
