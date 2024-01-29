ec2_prefix                = "wordpress-mysql"
min_size                  = 1
max_size                  = 1
desired_capacity          = 1
key_name                  = "ec2_instance_key" # specify the EC2 keypair here
instance_type             = "t3.micro"
health_check_grace_period = 300
