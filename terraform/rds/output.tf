output "hostname" {
  value = aws_db_instance.rds_mysql.address
}

output "dbname" {
  value = aws_db_instance.rds_mysql.name
}