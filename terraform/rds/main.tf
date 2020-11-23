resource "aws_db_instance" "rds_mysql" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0.21"
  instance_class    = "db.t3.micro"
  name              = "wordpress"
  username          = "wp_db_user"
  password          = "Pas$W0rd" # change this from AWS console
}