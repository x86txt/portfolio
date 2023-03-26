terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.59.0"
    }
  }

  # let's configure out backend locks for team sharing via s3
  backend "s3" {

    # s3 bucket info for lock sharing
    bucket = "devsec0ps-ninja-terraform-state"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"

    # DynamoDB tabel info for lock sharing
    dynamodb_table = "devsec0ps-terraform-locks"
    encrypt        = true

  }

}

# what region do we want to use?
provider "aws" {
  region = "us-east-1"
}
