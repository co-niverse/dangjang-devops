resource "aws_autoscaling_group" "asg" {
  name                      = var.name
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  vpc_zone_identifier       = var.vpc_zone_identifier
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  protect_from_scale_in     = var.protect_from_scale_in

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  instance_refresh {
    strategy = var.instance_refresh_strategy
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = var.propagate_at_launch
  }
}
