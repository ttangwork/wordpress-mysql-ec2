variable "ec2_prefix" {
  description = "prefix of ec2 instance"
  type        = string
  default     = "wordpress-mysql"
}
variable "min_size" {
  description = "minimum size of auto scaling group"
  type        = number
  default     = 1
}
variable "max_size" {
  description = "maximum size of auto scaling group"
  type        = number
  default     = 1
}
variable "desired_capacity" {
  description = "desired capacity of auto scaling group"
  type        = number
  default     = 1
}
variable "key_name" {
  description = "name of the ec2 key pair"
  type        = string
  default     = "ec2_instance_key"
}
variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t3.micro"
}
variable "health_check_grace_period" {
  description = "health check grace period"
  type        = number
  default     = 300
}
