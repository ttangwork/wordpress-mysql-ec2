data "aws_caller_identity" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "1efe223d-4333-7c13-d0dd-529f90283861-backend"
    key    = "network.tfstate"
    region = "ap-southeast-2"
  }
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["wordpress-mysql-image-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [data.aws_caller_identity.current.account_id]
}