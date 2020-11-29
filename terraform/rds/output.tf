output "hostname" {
  value = aws_db_instance.rds_mysql.address
}

output "endpoint" {
  value = aws_db_instance.rds_mysql.endpoint
}

output "dbname" {
  value = aws_db_instance.rds_mysql.name
}