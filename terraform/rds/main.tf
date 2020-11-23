resource "aws_db_instance" "rds_mysql" {
  identifier           = format("%s-rds-mysql", var.app_prefix)
  db_subnet_group_name = data.terraform_remote_state.vpc.outputs.private_subnet_id_for_rds
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