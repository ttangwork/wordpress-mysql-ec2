resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = format("%s-rds-subnet-group", var.db_prefix)
  subnet_ids = flatten([data.terraform_remote_state.vpc.outputs.private_subnet_ids])

  tags = {
    Name = format("%s-rds-subnet-group", var.db_prefix)
  }
}

resource "aws_security_group" "rds_sg" {
  name        = format("%s-rds_sg", var.db_prefix)
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
    Name = format("%s-rds-sg", var.db_prefix)
  }
}
resource "aws_db_instance" "rds_mysql" {
  identifier             = format("%s-rds-mysql", var.db_prefix)
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  allocated_storage      = 20
  storage_type           = var.db_storage
  engine                 = var.db_engine
  engine_version         = var.db_version
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password
  tags = {
    Name = format("%s-rds-mysql", var.db_prefix)
  }
}
