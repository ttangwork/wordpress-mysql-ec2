resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = format("%s-rds-subnet-group", var.app_prefix)
  subnet_ids = [data.terraform_remote_state.vpc.outputs.private_subnet_ids]

  tags = {
    Name = format("%s-rds-subnet-group", var.app_prefix)
  }
}
resource "aws_db_instance" "rds_mysql" {
  identifier           = format("%s-rds-mysql", var.app_prefix)
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.id
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.21"
  instance_class       = "db.t3.micro"
  name                 = "wordpress"
  username             = "wp_db_user"
  password             = "Pas$W0rd" # change this from AWS console
  tags = {
    Name = format("%s-rds-mysql", var.app_prefix)
  }
}