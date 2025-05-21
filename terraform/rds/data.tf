data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.backend_s3_bucket
    key    = "network.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = var.backend_s3_bucket # Assuming common bucket
    key    = "ec2.tfstate"         # Key for EC2 state
    region = var.aws_region        # Assuming common region
  }
}
