variable "service_name" {
  description = "service 이름"
  type        = string
}

variable "cluster_name" {
  description = "service가 생성될 cluster 이름"
  type        = string
}

variable "task_definition_arn" {
  description = "task definition arn"
  type        = string
}

variable "enable_execute_command" {
  description = "컨테이너 접속 허용 여부"
  type        = bool
  default     = true
}

variable "launch_type" {
  description = "service 실행 유형 (FARGATE, EC2) - task 실행 유형과 동일 (capacity provider strategy 사용 시 conflict 발생하므로 null로 설정)"
  type        = string
  default     = null
}

variable "desired_count" {
  description = "task 실행 횟수"
  type        = number
  default     = 1
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

variable "requires_iam_role" {
  description = "서비스에서 로드 밸런서를 사용할 때 필요한 IAM 역할 사용 여부 - network_mode가 awsvpc인 경우 필요없음"
  type        = bool
  default     = false
}

variable "network_configuration" {
  description = "네트워크 설정 - network_mode가 awsvpc인 경우 필수, 나머지는 지원하지 않음"
  type = object({
    subnets         = list(string)           # subnet ids
    security_groups = optional(list(string)) # security group ids
  })
  default = null
}

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
  description = "capacity provider 전략"
  type = list(object({
    capacity_provider = string # 용량 공급자 이름
    base              = number # task 최소 실행 개수
    weight            = number # 용량 공급자가 여러 개인 경우 task 실행 비율
  }))
  default = null
}

variable "ordered_placement_strategy" {
  description = "ordered placement 전략"
  type = list(object({
    type  = string # binpack, spread, random
    field = string # memory, cpu, ...
  }))
  default = null
}

variable "service_connect_configuration" {
  description = "service connect 설정"
  type = object({
    namespace = optional(string)        # cloud map namespace arn
    service = optional(object({         # 클라이언트-서버 모드일 때 사용
      port_name      = string           # task definition의 port mappings에서 정의한 포트 별칭
      discovery_name = optional(string) # ecs service의 namespace (생략할 경우 port_name 사용)
      client_alias = optional(object({  # 클라이언트 애플리케이션에서 사용할 수 있는 이름 할당
        port     = number               # service connect proxy가 수신하는 포트
        dns_name = optional(string)     # 기본값은 ${disconvery_name}.${namespace} 또는 ${port_name}.${namespace}
      }))
    }))
    log_configuration = optional(object({
      log_driver = string      # awslogs, fluentd, gelf, journald, json-file, splunk, syslog
      options    = map(string) # log driver 옵션
    }))
  })
  default = null
}
