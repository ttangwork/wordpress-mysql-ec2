terraform {
  backend "s3" {
    bucket = "tf-state-ttang"
    key    = "tfstate"
    region = "ap-southeast-2"
  }
}