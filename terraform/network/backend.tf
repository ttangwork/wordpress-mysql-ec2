terraform {
  backend "s3" {
    bucket = var.backend_s3_bucket
    key    = "network.tfstate"
    region = var.aws_region
  }
}
