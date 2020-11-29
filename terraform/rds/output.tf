output "hostname" {
  value = aws_db_instance.address
}

output "endpoint" {
  value = aws_db_instance.endpoint
}

output "dbname" {
  value = aws_db_instance.name
}