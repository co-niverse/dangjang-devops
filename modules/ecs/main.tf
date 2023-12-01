###################
#       ECS       #
###################

# ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
  tags = {
    Name = var.cluster_name
  }
}

resource "aws_ecs_capacity_provider" "cas" {
  name = var.cas_name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.auto_scaling_group_arn
    managed_termination_protection = var.managed_termination_protection

    managed_scaling {
      maximum_scaling_step_size = var.maximum_scaling_step_size
      minimum_scaling_step_size = var.minimum_scaling_step_size
      status                    = var.status
      target_capacity           = var.target_capacity
      instance_warmup_period    = var.instance_warmup_period
    }
  }

  tags = {
    Name = var.cas_name
  }
}

resource "aws_ecs_cluster_capacity_providers" "cas" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = [aws_ecs_capacity_provider.cas.name]
}

# # ECS Task Definition
# resource "aws_ecs_task_definition" "task" {
#   family                   = var.family
#   requires_compatibilities = var.requires_compatibilities
#   network_mode             = var.network_mode
#   cpu                      = var.task_cpu
#   memory                   = var.task_memory
#   task_role_arn            = data.aws_iam_role.ecs_task.arn
#   execution_role_arn       = data.aws_iam_role.ecs_task_execution.arn

#   runtime_platform {
#     operating_system_family = var.operating_system_family
#     cpu_architecture        = var.cpu_architecture
#   }

#   container_definitions = jsonencode([
#     {
#       name      = var.app_container_name
#       essential = true
#       image     = "${var.app_repository_url}:latest"
#       cpu       = var.app_cpu
#       memory    = var.app_memory

#       portMappings = [
#         {
#           containerPort = var.app_container_port
#           hostPort      = var.app_container_port
#         },
#         {
#           containerPort = var.app_container_health_port
#           hostPort      = var.app_container_health_port
#         }
#       ]
#     },
#     {
#       name      = var.fluentbit_container_name
#       essential = true
#       image     = "${var.fluentbit_repository_url}:latest"
#       cpu       = var.fluentbit_cpu
#       memory    = var.fluentbit_memory
#       portMappings = [
#         {
#           containerPort = var.fluentbit_port
#           hostPort      = var.fluentbit_port
#         }
#       ]
#       environment = var.fluentbit_environment
#     }
#   ])
# }

# # ECS Service
# resource "aws_ecs_service" "service" {
#   name                              = var.service_name
#   cluster                           = aws_ecs_cluster.cluster.name
#   task_definition                   = aws_ecs_task_definition.task.arn
#   enable_execute_command            = var.enable_execute_command
#   launch_type                       = var.launch_type
#   desired_count                     = var.desired_count
#   health_check_grace_period_seconds = var.health_check_grace_period_seconds
#   scheduling_strategy               = var.scheduling_strategy

#   network_configuration {
#     subnets         = var.subnets
#     security_groups = var.security_group
#   }

#   load_balancer {
#     target_group_arn = var.elb_target_group_arn
#     container_name   = var.app_container_name
#     container_port   = var.app_container_port
#   }

#   lifecycle {
#     ignore_changes = [desired_count]
#   }
# }
