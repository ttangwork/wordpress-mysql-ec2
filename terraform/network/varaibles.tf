variable "region" {
  description = "AWS Region"
  type        = string
}

variable "az_count" {
  description = "Number of availability zones"
  type        = number
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

variable "app_prefix" {
  description = "app prefix"
  type        = string
}
