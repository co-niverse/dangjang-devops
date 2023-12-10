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
  description = "컨테이너 이름"
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
    containerPort = number
    hostPort      = optional(number) # FARAGATE or awsvpc 네트워크일 경우 비워두거나 containerPort와 동일한 값
    name          = optional(string) # Service Connect 구성에 사용하는 포트 별칭
    appProtocol   = optional(string) # Service Connect 구성에 사용하는 프로토콜 (default: tcp, available: http, http2, grpc)
  }))
}

variable "environment" {
  description = "컨테이너 환경변수"
  type = list(object({
    name  = string
    value = string
  }))
  default = null
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