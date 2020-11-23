data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "1efe223d-4333-7c13-d0dd-529f90283861-backend"
    key    = "network.tfstate"
    region = "ap-southeast-2"
  }
}