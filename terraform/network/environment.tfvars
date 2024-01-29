region               = "ap-southeast-2"
az_count             = 2
network_prefix       = "wordpress-mysql"
vpc_cidr             = "10.0.0.0/16"
private_subnet_cidrs = ["10.0.1.0/24", "10.0.3.0/24"]
public_subnet_cidrs  = ["10.0.5.0/24", "10.0.7.0/24"]