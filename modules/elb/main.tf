# ELB
resource "aws_lb" "default" {
  name               = var.elb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.elb_name
  }
}

# ELB target group
resource "aws_alb_target_group" "default" {
  name                 = var.target_group_name
  target_type          = var.target_type
  port                 = var.target_port
  protocol             = var.target_protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay

  health_check {
    port                = var.health_check_port
    interval            = var.interval
    path                = var.ping_path
    matcher             = var.matcher
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = {
    Name = var.target_group_name
  }
}

# ELB listener
resource "aws_alb_listener" "default" {
  load_balancer_arn = aws_lb.default.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_domain

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.default.arn
  }
}
