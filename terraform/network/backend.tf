terraform {
  backend "s3" {
    bucket = "USE_YOUR_OWN_S3_BUCKET"
    key    = "network.tfstate"
    region = "ap-southeast-2"
  }
}