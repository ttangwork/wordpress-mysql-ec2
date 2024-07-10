# security groups
resource "aws_security_group" "alb_sg" {
  name        = format("%s-alb_sg", var.ec2_prefix)
  description = "Allow inbound HTTP traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "HTTP inbound"
    from_port   = var.alb_ingress_from
    to_port     = var.alb_ingress_to
    protocol    = var.alb_ingress_protocol
    cidr_blocks = var.alb_ingress_cidr
  }

  egress {
    from_port   = var.alb_egress_from
    to_port     = var.alb_egress_to
    protocol    = var.alb_egress_protocol
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }

  tags = {
    Name = format("%s-alb-sg", var.ec2_prefix)
  }
}

resource "aws_security_group" "asg_sg" {
  name        = format("%s-asg_sg", var.ec2_prefix)
  description = "Allow inbound HTTP traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description     = "Inbound HTTP from ALB"
    from_port       = var.asg_ingress_from
    to_port         = var.asg_ingress_to
    protocol        = var.asg_ingress_protocol
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = var.asg_ingress_from
    to_port     = var.asg_ingress_to
    protocol    = var.asg_egress_protocol
    cidr_blocks = var.asg_egress_cidr
  }

  tags = {
    Name = format("%s-asg-sg", var.ec2_prefix)
  }
}

# application load balancer
resource "aws_lb" "lb" {
  name               = format("%s-lb", var.ec2_prefix)
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  tags = {
    Name = format("%s-lb", var.ec2_prefix)
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = format("%s-lb-target-group", var.ec2_prefix)
  port     = var.lb_target_group_port
  protocol = var.lb_target_group_protocol
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = var.lb_listener_action_type
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

# launch configuration
resource "aws_launch_configuration" "lc" {
  name            = format("%s-lc", var.ec2_prefix)
  image_id        = data.aws_ami.ami.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.asg_sg.id]
}

# auto scaling group
resource "aws_autoscaling_group" "asg" {
  name                      = format("%s-asg", var.ec2_prefix)
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  target_group_arns         = [aws_lb_target_group.lb_target_group.arn]
  force_delete              = var.asg_force_delete
  launch_configuration      = aws_launch_configuration.lc.name
  vpc_zone_identifier       = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  tag {
    key                 = "Name"
    value               = format("%s-asg", var.ec2_prefix)
    propagate_at_launch = true
  }
}
