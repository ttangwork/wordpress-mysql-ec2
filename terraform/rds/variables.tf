variable "db_prefix" {
  description = "database prefix"
  type        = string
}
variable "db_instance_class" {
  description = "RDS db instance class"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}
variable "db_user" {
  description = "Database user name"
  type        = string
  sensitive   = true
}
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "db_version" {
  description = "Database engine version"
  type        = string
}

variable "db_storage" {
  description = "Database storage type"
  type        = string
}