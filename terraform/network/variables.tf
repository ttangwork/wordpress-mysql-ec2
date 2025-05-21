variable "region" {
  description = "AWS Region" # This is for AZ construction like ap-southeast-2a, not the provider region
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

variable "az_list" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["a", "b", "c", "d"]
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "network_prefix" {
  description = "network prefix"
  type        = string
}
