data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}

resource "aws_ecs_service" "service" {
  name                              = var.service_name
  cluster                           = var.cluster_name
  task_definition                   = var.task_definition_arn
  enable_execute_command            = var.enable_execute_command
  launch_type                       = var.launch_type
  desired_count                     = var.desired_count
  scheduling_strategy               = var.scheduling_strategy
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  iam_role                          = var.requires_iam_role ? data.aws_iam_role.ecs_service_role.arn : null

  dynamic "network_configuration" {
    for_each = var.network_configuration != null ? [1] : []
    content {
      subnets         = var.network_configuration.subnets
      security_groups = var.network_configuration.security_groups
    }
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer != null ? [1] : []
    content {
      target_group_arn = var.load_balancer.target_group_arn
      container_name   = var.load_balancer.container_name
      container_port   = var.load_balancer.container_port
    }

  }

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

  dynamic "service_connect_configuration" {
    for_each = var.service_connect_configuration != null ? [1] : []
    content {
      enabled   = true
      namespace = var.service_connect_configuration.namespace

      dynamic "service" {
        for_each = var.service_connect_configuration.service != null ? [1] : []
        content {
          port_name      = var.service_connect_configuration.service.port_name
          discovery_name = var.service_connect_configuration.service.discovery_name
          client_alias {
            port     = var.service_connect_configuration.service.client_alias.port
            dns_name = var.service_connect_configuration.service.client_alias.dns_name
          }
        }
      }
      dynamic "log_configuration" {
        for_each = var.service_connect_configuration.log_configuration != null ? [1] : []
        content {
          log_driver = var.service_connect_configuration.log_configuration.log_driver
          options    = var.service_connect_configuration.log_configuration.options
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}
