resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = format("%s-rds-subnet-group", var.app_prefix)
  subnet_ids = flatten([data.terraform_remote_state.vpc.outputs.private_subnet_ids])

  tags = {
    Name = format("%s-rds-subnet-group", var.app_prefix)
  }
}

resource "aws_security_group" "rds_sg" {
  name        = format("%s-rds_sg", var.app_prefix)
  description = "Allow EC2 to access RDS"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "DB inbound"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }

  tags = {
    Name = format("%s-rds-sg", var.app_prefix)
  }
}
resource "aws_db_instance" "rds_mysql" {
  identifier             = format("%s-rds-mysql", var.app_prefix)
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0.21"
  instance_class         = "db.t3.micro"
  name                   = "wordpress"
  username               = var.db_user
  password               = var.db_password
  tags = {
    Name = format("%s-rds-mysql", var.app_prefix)
  }
}