locals {
  default_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]
  enabled_metrics = var.metrics != null ? toset(concat(local.default_metrics, var.metrics)) : local.default_metrics
}

resource "aws_autoscaling_group" "asg" {
  name                      = var.name
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  vpc_zone_identifier       = var.vpc_zone_identifier
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  protect_from_scale_in     = var.protect_from_scale_in
  metrics_granularity       = var.metrics_granularity
  enabled_metrics           = local.enabled_metrics

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  instance_refresh {
    strategy = var.instance_refresh_strategy
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ desired_capacity ]
  }

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = var.propagate_at_launch
  }

  dynamic "tag" {
    for_each = var.ecs_managed ? [1] : []
    content {
      key                 = "AmazonECSManaged"
      value               = true
      propagate_at_launch = true
    }
    
  }
}
