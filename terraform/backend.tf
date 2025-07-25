terraform {
  backend "s3" {
    bucket = "yadin-tfstate-bucket"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}
