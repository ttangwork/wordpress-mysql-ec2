terraform {
  backend "s3" {
    bucket = var.backend_s3_bucket
    key    = "ec2.tfstate"
    region = var.aws_region
  }
}
