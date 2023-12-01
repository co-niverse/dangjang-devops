resource "aws_ecs_service" "service" {
  name                              = var.service_name
  cluster                           = var.cluster_name
  task_definition                   = var.task_definition_arn
  enable_execute_command            = var.enable_execute_command
  launch_type                       = var.launch_type
  desired_count                     = var.desired_count
  scheduling_strategy               = var.scheduling_strategy
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  iam_role                          = var.iam_role_arn

  dynamic "network_configuration" {
    for_each = var.network_configuration != null ? [1] : []
    content {
      subnets         = var.network_configuration.subnets
      security_groups = var.network_configuration.security_groups
    }
  }

  # network_configuration {
  #   subnets         = var.subnets
  #   security_groups = var.security_group
  # }

  dynamic "load_balancer" {
    for_each = var.load_balancer != null ? [1] : []
    content {
      target_group_arn = var.load_balancer.target_group_arn
      container_name   = var.load_balancer.container_name
      container_port   = var.load_balancer.container_port
    }

  }
  # load_balancer {
  #   target_group_arn = var.elb_target_group_arn
  #   container_name   = var.container_name
  #   container_port   = var.container_port
  # }

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy != null ? var.capacity_provider_strategy : []
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      base              = capacity_provider_strategy.value.base
      weight            = capacity_provider_strategy.value.weight
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy != null ? var.ordered_placement_strategy : []
    content {
      type  = ordered_placement_strategy.value.type
      field = ordered_placement_strategy.value.field
    }
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}
