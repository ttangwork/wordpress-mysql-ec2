data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "USE_YOUR_OWN_S3_BUCKET"
    key    = "network.tfstate"
    region = "ap-southeast-2"
  }
}