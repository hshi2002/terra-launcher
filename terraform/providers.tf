terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  default_tags {
    tags = {
      Owner           = "Yadin-TF-task1"
      expiration_date = "30-07-25"
    }
  }
}
