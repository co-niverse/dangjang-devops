###################
#       ECS       #
###################

variable "cluster_name" {
  description = "cluster 이름"
  type        = string
}

variable "family" {
  description = "테스크 정의 family"
  type        = string
}

variable "network_mode" {
  description = "docker 네트워킹 모드 (awsvpc, bridge, host, none)"
  type        = string
  default     = "awsvpc"
}

variable "task_cpu" {
  description = "task에 할당할 cpu (requires_compatibilities == FARGATE 일 경우 필수)"
  type        = number
}

variable "task_memory" {
  description = "task에 할당할 memory (requires_compatibilities == FARGATE 일 경우 필수)"
  type        = number
}

variable "operating_system_family" {
  description = "task의 런타임 플랫폼 (requires_compatibilities == FARGATE 일 경우 필수)"
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "cpu 아키텍처"
  type        = string
  default     = "ARM64"
}

variable "app_container_name" {
  description = "앱 컨테이너 이름 (로드밸런서 연결)"
  type        = string
}

variable "app_repository_url" {
  description = "앱 컨테이너 이미지 저장소 url"
  type        = string  
}

variable "app_cpu" {
  description = "앱 컨테이너에 할당할 cpu"
  type        = number
}

variable "app_memory" {
  description = "앱 컨테이너에 할당할 memory"
  type        = number
}

variable "app_container_port" {
  description = "앱 컨테이너 포트 (로드밸런서 연결)"
  type        = number
}

variable "app_container_health_port" {
  description = "앱 컨테이너 health check 포트"
  type        = number
}

variable "fluentbit_container_name" {
  description = "fluentbit 컨테이너 이름"
  type        = string
}

variable "fluentbit_repository_url" {
  description = "fluentbit 컨테이너 이미지 저장소 url"
  type        = string
}

variable "fluentbit_cpu" {
  description = "fluentbit 컨테이너에 할당할 cpu"
  type        = number
}
  
variable "fluentbit_memory" {
  description = "fluentbit 컨테이너에 할당할 memory"
  type        = number
}
  
variable "fluentbit_port" {
  description = "fluentbit 컨테이너 포트"
  type        = number
}

variable "fluentbit_environment" {
  description = "fluentbit 컨테이너 환경변수"
  type        = list(object({
    name  = string
    value = string
  }))
}

variable "service_name" {
  description = "service 이름"
  type        = string
}

variable "enable_execute_command" {
  description = "컨테이너 접속 허용"
  type        = bool
  default     = true
}

variable "launch_type" {
  description = "FARGATE or EC2"
  type        = string
  default     = "EC2"
}

variable "desired_count" {
  description = "task 실행 횟수"
  type        = number
}

variable "health_check_grace_period_seconds" {
  description = "로드밸런서의 health check 대기 시간(sec) - 새로 생성된 task의 조기 종료 방지"
  type        = number
  default     = 180
}

variable "subnets" {
  description = "task 또는 service와 연결할 서브넷"
  type        = list(string)
}

variable "security_group" {
  description = "task 또는 service와 연결할 보안그룹"
  type        = list(string)
}

variable "elb_target_group_arn" {
  description = "로드밸런서의 target group arn"
  type        = string
}