# security groups
resource "aws_security_group" "alb_sg" {
  name        = format("%s-alb_sg", var.app_prefix)
  description = "Allow inbound HTTP traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "HTTP inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }

  tags = {
    Name = format("%s-alb-sg", var.app_prefix)
  }
}

resource "aws_security_group" "asg_sg" {
  name        = format("%s-asg_sg", var.app_prefix)
  description = "Allow inbound HTTP traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description     = "Inbound HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-asg-sg", var.app_prefix)
  }
}

# application load balancer
resource "aws_lb" "lb" {
  name               = format("%s-lb", var.app_prefix)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  tags = {
    Name = format("%s-lb", var.app_prefix)
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = format("%s-lb-target-group", var.app_prefix)
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

# launch configuration
resource "aws_launch_configuration" "lc" {
  name            = format("%s-lc", var.app_prefix)
  image_id        = data.aws_ami.ami.id
  instance_type   = "t3.micro"
  key_name = var.key_name
  security_groups = [aws_security_group.asg_sg.id]
}

# auto scaling group
resource "aws_autoscaling_group" "asg" {
  name                      = format("%s-asg", var.app_prefix)
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.lb_target_group.arn]
  force_delete              = true
  launch_configuration      = aws_launch_configuration.lc.name
  vpc_zone_identifier       = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  tag {
    key                 = "Name"
    value               = format("%s-asg", var.app_prefix)
    propagate_at_launch = true
  }
}