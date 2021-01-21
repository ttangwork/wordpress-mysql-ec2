terraform {
  backend "remote" {
    organization = "ttangwork"

    workspaces {
      name = "wordpress-mysql-ec2"
    }
  }
}