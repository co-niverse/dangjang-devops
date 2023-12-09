data "aws_iam_role" "ecs_task" {
  name = "ecs-task-role"
}

data "aws_iam_role" "ecs_task_execution" {
  name = "ecs-task-execution-role"
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.family
  requires_compatibilities = var.requires_compatibilities
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
      name             = var.container_name
      essential        = var.essential
      image            = "${var.repository_url}:${var.tag}"
      cpu              = var.container_cpu
      memory           = var.container_memory
      portMappings     = var.port_mappings
      environment      = var.environment
      logConfiguration = var.log_configuration
    }
  ])
}
