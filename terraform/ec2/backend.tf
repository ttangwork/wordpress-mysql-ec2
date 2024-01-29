terraform {
  backend "s3" {
    bucket = "USE_YOUR_OWN_S3_BUCKET"
    key    = "ec2.tfstate"
    region = "ap-southeast-2"
  }
}
