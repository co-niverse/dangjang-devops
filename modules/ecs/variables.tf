###################
#       ECS       #
###################

variable "cluster_name" {
  description = "cluster 이름"
  type        = string
}

variable "cas_name" {
  description = "capacity provider 이름 (Cluster Auto Scaling)"
  type        = string
}

variable "auto_scaling_group_arn" {
  description = "ASG의 arn"
  type        = string
}

variable "managed_termination_protection" {
  description = "scale in 이벤트 때 task가 실행 중인 instance는 종료되지 않도록 보호"
  type        = string
  default     = "ENABLED"
}

variable "maximum_scaling_step_size" {
  description = "cas가 scale in/out 할 때 최대로 조정할 수 있는 instance 개수 (1 ~ 10,000)"
  type        = number
  default     = 1
}

variable "minimum_scaling_step_size" {
  description = "cas가 scale in/out 할 때 최소로 조정할 수 있는 instance 개수 (1 ~ 10,000)"
  type        = number
  default     = 1
}

variable "status" {
  description = "ECS가 ASG의 scale in/out 관리"
  type        = string
  default     = "ENABLED"
}

variable "target_capacity" {
  description = "Capacity Provider Reservation 매트릭 목표 수치 (1 ~ 100)"
  type        = number
  default     = 100
}

variable "instance_warmup_period" {
  description = "새로운 instance가 시작됐을 때 CloudWatch 매트릭에 반영되기까지의 시간 (sec)"
  type        = number
  default     = 300
}

# variable "family" {
#   description = "task 정의 이름"
#   type        = string
# }

# variable "requires_compatibilities" {
#   description = "task 실행 유형 (FARGATE, EC2, EXTERNAL)"
#   type        = list(string)
# }

# variable "network_mode" {
#   description = "docker 네트워킹 모드 (awsvpc, bridge, host, none) - requires_compatibilities == FARGATE일 경우 awsvpc만 가능"
#   type        = string
#   default     = "awsvpc"
# }

# variable "task_cpu" {
#   description = "task에 할당할 cpu - requires_compatibilities == FARGATE일 경우 필수"
#   type        = number
#   default = null
# }

# variable "task_memory" {
#   description = "task에 할당할 memory - requires_compatibilities == FARGATE일 경우 필수"
#   type        = number
#   default = null
# }

# variable "operating_system_family" {
#   description = "task 컨테이너의 OS (LINUX, WINDOWS...) - requires_compatibilities == FARGATE일 경우 LINUX 필수"
#   type        = string
#   default     = "LINUX"
# }

# variable "cpu_architecture" {
#   description = "task 컨테이너의 cpu architecture (X86_64, ARM64)"
#   type        = string
#   default     = "ARM64"
# }

# variable "app_container_name" {
#   description = "앱 컨테이너 이름 (로드밸런서 연결)"
#   type        = string
# }

# variable "app_repository_url" {
#   description = "앱 컨테이너 이미지 저장소 url"
#   type        = string  
# }

# variable "app_cpu" {
#   description = "앱 컨테이너에 할당할 cpu"
#   type        = number
# }

# variable "app_memory" {
#   description = "앱 컨테이너에 할당할 memory"
#   type        = number
# }

# variable "app_container_port" {
#   description = "앱 컨테이너 포트 (로드밸런서 연결)"
#   type        = number
# }

# variable "app_container_health_port" {
#   description = "앱 컨테이너 health check 포트"
#   type        = number
# }

# variable "fluentbit_container_name" {
#   description = "fluentbit 컨테이너 이름"
#   type        = string
# }

# variable "fluentbit_repository_url" {
#   description = "fluentbit 컨테이너 이미지 저장소 url"
#   type        = string
# }

# variable "fluentbit_cpu" {
#   description = "fluentbit 컨테이너에 할당할 cpu"
#   type        = number
# }
  
# variable "fluentbit_memory" {
#   description = "fluentbit 컨테이너에 할당할 memory"
#   type        = number
# }
  
# variable "fluentbit_port" {
#   description = "fluentbit 컨테이너 포트"
#   type        = number
# }

# variable "fluentbit_environment" {
#   description = "fluentbit 컨테이너 환경변수"
#   type        = list(object({
#     name  = string
#     value = string
#   }))
# }

# variable "service_name" {
#   description = "service 이름"
#   type        = string
# }

# variable "enable_execute_command" {
#   description = "컨테이너 접속 허용"
#   type        = bool
#   default     = true
# }

# variable "launch_type" {
#   description = "FARGATE or EC2"
#   type        = string
# }

# variable "desired_count" {
#   description = "task 실행 횟수"
#   type        = number
# }

# variable "scheduling_strategy" {
#   description = "service 스케줄링 전략 (REPLICA, DAEMON)"
#   type        = string
#   default     = "REPLICA"
# }

# variable "health_check_grace_period_seconds" {
#   description = "로드밸런서의 health check 대기 시간(sec) - 새로 생성된 task의 조기 종료 방지"
#   type        = number
#   default     = 180
# }

# variable "subnets" {
#   description = "task 또는 service와 연결할 서브넷"
#   type        = list(string)
# }

# variable "security_group" {
#   description = "task 또는 service와 연결할 보안그룹"
#   type        = list(string)
# }

# variable "elb_target_group_arn" {
#   description = "로드밸런서의 target group arn"
#   type        = string
# }