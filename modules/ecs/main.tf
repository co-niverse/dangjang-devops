###################
#       ECS       #
###################

locals {
  default_capacity_providers = var.enabled_fargate_cas ? ["FARGATE", "FARGATE_SPOT"] : []
}

# ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
  tags = {
    Name = var.cluster_name
  }
}

# Cluster Auto Scaling
resource "aws_ecs_capacity_provider" "cas" {
  for_each = var.cas
  name     = each.key

  auto_scaling_group_provider {
    auto_scaling_group_arn         = each.value.auto_scaling_group_arn
    managed_termination_protection = each.value.managed_termination_protection

    managed_scaling {
      maximum_scaling_step_size = each.value.maximum_scaling_step_size
      minimum_scaling_step_size = each.value.minimum_scaling_step_size
      status                    = each.value.status
      target_capacity           = each.value.target_capacity
      instance_warmup_period    = each.value.instance_warmup_period
    }
  }

  tags = {
    Name = each.key
  }
}

# ECS Cluster Capacity Providers
resource "aws_ecs_cluster_capacity_providers" "cas" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = var.cas != null ? concat(local.default_capacity_providers, [for cas in aws_ecs_capacity_provider.cas : cas.name]) : local.default_capacity_providers
}
