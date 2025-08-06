terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws-region
  default_tags {
    tags = {
        IAC = "terraform"
        Environment = terraform.workspace
    }
  }
}


terraform {
  backend "s3" {
    bucket = "tienda-andromeda-backup"
    key    = "aws/s3/prod/s3.tfstate"
    region = "us-east-1"
  }
}
