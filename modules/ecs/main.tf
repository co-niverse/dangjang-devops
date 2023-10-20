###################
#       ECS       #
###################

# ECS role
data "aws_iam_role" "ecs_task" {
  name = "ecs-task-role"
}

data "aws_iam_role" "ecs_task_execution" {
  name = "ecs-task-execution-role"
}

# ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
  tags = {
    Name = var.cluster_name
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "task" {
  family                   = var.family
  network_mode             = var.network_mode
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  task_role_arn            = data.aws_iam_role.ecs_task.arn
  execution_role_arn       = data.aws_iam_role.ecs_task_execution.arn

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  container_definitions = jsonencode([
    {
      name      = var.app_container_name
      essential = true
      image     = "${var.app_repository_url}:latest"
      cpu       = var.app_cpu
      memory    = var.app_memory

      portMappings = [
        {
          containerPort = var.app_container_port
          hostPort      = var.app_container_port
        },
        {
          containerPort = var.app_container_health_port
          hostPort      = var.app_container_health_port
        }
      ]
    },
    {
      name      = var.fluentbit_container_name
      essential = true
      image     = "${var.fluentbit_repository_url}:latest"
      cpu       = var.fluentbit_cpu
      memory    = var.fluentbit_memory
      portMappings = [
        {
          containerPort = var.fluentbit_port
          hostPort      = var.fluentbit_port
        }
      ]
      environment = var.fluentbit_environment
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "service" {
  name                              = var.service_name
  cluster                           = aws_ecs_cluster.cluster.name
  task_definition                   = aws_ecs_task_definition.task.arn
  enable_execute_command            = var.enable_execute_command
  launch_type                       = var.launch_type
  desired_count                     = var.desired_count
  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_group
  }

  load_balancer {
    target_group_arn = var.elb_target_group_arn
    container_name   = var.app_container_name
    container_port   = var.app_container_port
  }
}
