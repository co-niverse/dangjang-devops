# Task Definition
variable "family" {
  description = "task 정의 이름"
  type        = string
}

variable "requires_compatibilities" {
  description = "task 실행 유형 (FARGATE, EC2, EXTERNAL)"
  type        = list(string)
}

variable "network_mode" {
  description = "docker 네트워킹 모드 (awsvpc, bridge, host, none) - FARGATE : awsvpc, LINUX Instance : all, WINDOWS Instance : NAT(default), awsvpc"
  type        = string
  default     = "awsvpc"
}

variable "task_cpu" {
  description = "task에 할당할 cpu - FARGATE 필수"
  type        = number
  default     = null
}

variable "task_memory" {
  description = "task에 할당할 memory - FARGATE 필수"
  type        = number
  default     = null
}

variable "operating_system_family" {
  description = "task 컨테이너의 OS (LINUX, WINDOWS...) - FARGATE -> LINUX 필수"
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "task 컨테이너의 cpu architecture (X86_64, ARM64)"
  type        = string
  default     = "ARM64"
}

variable "container_name" {
  description = "컨테이너 이름 (로드밸런서 연결)"
  type        = string
}

variable "essential" {
  description = "필수 컨테이너 여부"
  type        = bool
  default     = true
}

variable "repository_url" {
  description = "컨테이너 이미지 저장소 url"
  type        = string
}

variable "tag" {
  description = "컨테이너 이미지 tag"
  type        = string
  default     = "latest"
}

variable "container_cpu" {
  description = "컨테이너에 할당할 cpu"
  type        = number
}

variable "container_memory" {
  description = "컨테이너에 할당할 memory"
  type        = number
}

variable "port_mappings" {
  description = "컨테이너 포트 매핑"
  type = list(object({
    host_port      = number
    container_port = number
  }))
}

variable "log_configuration" {
  description = "컨테이너 로그 설정"
  type = object({
    logDriver = string
    options = object({
      awslogs-group         = string # 생성한 로그 그룹 이름
      awslogs-region        = string # 리전
      awslogs-stream-prefix = string # 로그 스트림 이름
    })
  })
  default = null
}

# Service
variable "service_name" {
  description = "service 이름"
  type        = string
}

variable "cluster_name" {
  description = "service가 생성될 cluster 이름"
  type        = string
}

variable "enable_execute_command" {
  description = "컨테이너 접속 허용 여부"
  type        = bool
  default     = true
}

variable "launch_type" {
  description = "service 실행 유형 (FARGATE, EC2) - task 실행 유형과 동일"
  type        = string
}

variable "desired_count" {
  description = "task 실행 횟수"
  type        = number
}

variable "scheduling_strategy" {
  description = "service 스케줄링 전략 (REPLICA, DAEMON)"
  type        = string
  default     = "REPLICA"
}

variable "health_check_grace_period_seconds" {
  description = "로드밸런서의 health check 대기 시간(sec) - 새로 생성된 task의 조기 종료 방지"
  type        = number
  default     = null
}

variable "iam_role_arn" {
  description = "서비스에서 로드 밸런서를 사용할 때 필요한 IAM 역할 - network_mode가 awsvpc인 경우 필요없음"
  type        = string
  default     = null
}

variable "network_configuration" {
  description = "네트워크 설정 - network_mode가 awsvpc인 경우 필수, 나머지는 지원하지 않음"
  type = object({
    subnets         = list(string) # subnet ids
    security_groups = list(string) # security group ids
  })
  default = null
}

# variable "subnets" {
#   description = "task 또는 service와 연결할 서브넷"
#   type        = list(string)
# }

# variable "security_group" {
#   description = "task 또는 service와 연결할 보안그룹"
#   type        = list(string)
# }

variable "load_balancer" {
  description = "로드밸런서 연결"
  type = object({
    target_group_arn = string # 로드밸런서의 target group arn
    container_name   = string # 연결할 컨테이너 이름
    container_port   = number # 연결할 컨테이너 포트
  })
  default = null
}

variable "capacity_provider_strategy" {
  description = "서비스에 대한 capacity provider 전략"
  type = list(object({
    capacity_provider = string # 용량 공급자 이름
    base              = number # task 최소 실행 개수
    weight            = number # 용량 공급자가 여러 개인 경우 task 실행 비율
  }))
  default = null
}

variable "ordered_placement_strategy" {
  description = "서비스에 대한 ordered placement 전략"
  type = list(object({
    type  = string # binpack, spread, random
    field = string # memory, cpu, ...
  }))
  default = null
}

# variable "elb_target_group_arn" {
#   description = "로드밸런서의 target group arn"
#   type        = string
# }
