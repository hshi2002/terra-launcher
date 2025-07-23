terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  access_key = "AKIARX27KZNM7MSULQHK"
  secret_key = "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"
  default_tags {
    tags = {
      Owner           = "Yadin-TF-task1"
      expiration_date = "30-07-25"
    }
  }
}
