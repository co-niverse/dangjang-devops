###################
#       ECS       #
###################

# ECS Cluster
resource "aws_ecs_cluster" "app" {
  name = "ecs-cluster-${var.env}"
  tags = {
    Name = "ecs-cluster-${var.env}"
  }
}

# # ECS Service - api
# resource "aws_ecs_service" "api" {
#   name                   = "ecs-service-api-${var.env}"
#   cluster                = aws_ecs_cluster.app.name
#   task_definition        = aws_ecs_task_definition.api.arn
#   enable_execute_command = true # 컨테이너 접속 허용
#   launch_type            = "FARGATE"
#   desired_count          = var.desired_count # task 실행 횟수

#   network_configuration {
#     subnets         = var.private_subnets # 서브넷 등록
#     security_groups = ["${var.app_security_group}"]
#   }

#   load_balancer {
#     target_group_arn = var.elb_target_group_arn
#     container_name   = "api-container-${var.env}"
#     container_port   = 8080
#   }
# }

# ECS Task Definition - api
resource "aws_ecs_task_definition" "api" {
  family                   = "ecs-template-api-${var.env}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture = "ARM64"
  }

  container_definitions = jsonencode([
    {
      essential = true
      name      = "api-container-${var.env}"
      image     = "${var.ecr_repository_url}"
      cpu       = 2048
      memory    = 4096

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    },
    {
      essential = true
      name      = "fluentbit-${var.env}"
      image     = "public.ecr.aws/aws-observability/aws-for-fluent-bit:stable" # 수정
      cpu       = 512
      memory    = 512

      portMappings = [
        {
          containerPort = 2020
          hostPort      = 2020
        }
      ]
    }
  ])
}
