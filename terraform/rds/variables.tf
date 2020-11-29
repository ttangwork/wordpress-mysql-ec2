variable "app_prefix" {
  description = "app prefix"
  type        = string
}
variable "db_instance_class" {
  description = "RDS db instance class"
  type = string
}

variable "db_name" {
  description = "Database name"
  type = string
}
variable "db_user" {
  description = "Database user name"
  type = string
}

variable "db_password" {
  description = "Database password"
  type = string
}