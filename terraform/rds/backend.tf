terraform {
  backend "s3" {
    bucket = "USE_YOUR_OWN_S3_BUCKET"
    key    = "rds.tfstate"
    region = "ap-southeast-2"
  }
}