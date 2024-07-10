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
variable "health_check_type" {
  description = "health check type"
  type        = string
  default     = "ELB"
}
variable "health_check_grace_period" {
  description = "health check grace period"
  type        = number
  default     = 300
}
variable "asg_force_delete" {
  description = "asg force delete boolean switch"
  type        = bool
  default     = true
}

## alb security group
variable "alb_ingress_cidr" {
  description = "alb ingress cidr"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "alb_ingress_from" {
  description = "alb ingress from port"
  type        = number
  default     = 80
}
variable "alb_ingress_to" {
  description = "alb ingress to port"
  type        = number
  default     = 80
}
variable "alb_ingress_protocol" {
  description = "alb ingress protocol"
  type        = string
  default     = "tcp"
}
variable "alb_egress_from" {
  description = "alb egress from port"
  type        = number
  default     = 0
}
variable "alb_egress_to" {
  description = "alb egress to port"
  type        = number
  default     = 0
}
variable "alb_egress_protocol" {
  description = "alb egress protocol"
  type        = string
  default     = "-1"
}

## asg security group
variable "asg_egress_cidr" {
  description = "asg egress cidr"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "asg_ingress_from" {
  description = "asg ingress from port"
  type        = number
  default     = 80
}
variable "asg_ingress_to" {
  description = "asg ingress to port"
  type        = number
  default     = 80
}
variable "asg_ingress_protocol" {
  description = "asg ingress protocol"
  type        = string
  default     = "tcp"
}
variable "asg_egress_from" {
  description = "asg egress from port"
  type        = number
  default     = 0
}
variable "asg_egress_to" {
  description = "asg egress to port"
  type        = number
  default     = 0
}
variable "asg_egress_protocol" {
  description = "asg egress protocol"
  type        = string
  default     = "-1"
}

##lb
variable "lb_internal" {
  description = "boolean switch - internal or external lb"
  type        = bool
  default     = false
}
variable "lb_type" {
  description = "lb type"
  type        = string
  default     = "application"
}
variable "lb_target_group_port" {
  description = "lb target group port"
  type        = number
  default     = 80
}
variable "lb_target_group_protocol" {
  description = "lb target group protocol"
  type        = string
  default     = "HTTP"
}
variable "lb_listener_port" {
  description = "lb listener port"
  type        = string
  default     = "80"
}
variable "lb_listener_protocol" {
  description = "lb listener protocol"
  type        = string
  default     = "HTTP"
}
variable "lb_listener_action_type" {
  description = "lb listener default action type"
  type        = string
  default     = "forward"
}