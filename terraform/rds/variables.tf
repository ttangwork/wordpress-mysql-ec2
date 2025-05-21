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

# For production environments, it is highly recommended to manage the database
# password using AWS Secrets Manager or a similar service and retrieve it
# using a data source instead of passing it as a direct variable.
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
variable "ingress_from_port" {
  description = "ingress from port"
  type        = number
  default     = 3306
}
variable "ingress_to_port" {
  description = "ingress to port"
  type        = number
  default     = 3306
}
variable "egress_from_port" {
  description = "egress from port"
  type        = number
  default     = 0
}
variable "egress_to_port" {
  description = "egress to port"
  type        = number
  default     = 0
}
variable "protocol" {
  description = "db transport protocol"
  type        = string
  default     = "tcp"
}
variable "allocated_storage" {
  description = "db allocated storage in GB"
  type        = number
  default     = 20
}

variable "ec2_asg_security_group_id" {
  description = "The security group ID of the EC2 Auto Scaling Group that needs access to the RDS instance."
  type        = string
}

variable "aws_region" {
  description = "AWS region for provider."
  type        = string
  default     = "ap-southeast-2" # From previous hardcoded value in provider
}

variable "backend_s3_bucket" {
  description = "S3 bucket for Terraform backend state files."
  type        = string
  # No default value
}