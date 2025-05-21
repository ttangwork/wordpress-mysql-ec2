output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "asg_security_group_id" {
  description = "The ID of the ASG security group."
  value       = aws_security_group.asg_sg.id
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.lb.dns_name
}
