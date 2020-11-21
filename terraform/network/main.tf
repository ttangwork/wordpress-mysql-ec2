resource "aws_vpc" "wp-mysql-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "wp-mysql-vpc"
  }
}

resource "aws_subnet" "wp-mysql-subnet-1" {
  vpc_id            = aws_vpc.wp-mysql-vpc.id
  cidr_block        = var.subnet_1_cidr
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "wp-mysql-subnet-1"
  }
}

resource "aws_subnet" "wp-mysql-subnet-2" {
  vpc_id            = aws_vpc.wp-mysql-vpc.id
  cidr_block        = var.subnet_2_cidr
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "wp-mysql-subnet-2"
  }
}