###################
#       ECS       #
###################

variable "cluster_name" {
  description = "cluster 이름"
  type        = string
}

variable "namespace_arn" {
  description = "service discovery namespace arn"
  type        = string
  default     = null
}

variable "cas" {
  description = "capacity provider 설정"
  type = map(object({
    auto_scaling_group_arn         = string           # ASG의 arn
    managed_termination_protection = string           # scale in 이벤트 때 task가 실행 중인 instance는 종료되지 않도록 보호 (ENABLED, DISABLED)
    maximum_scaling_step_size      = optional(number) # cas가 scale in/out 할 때 최대로 조정할 수 있는 instance 개수 (1 ~ 10,000) default: 10,000
    minimum_scaling_step_size      = optional(number) # cas가 scale in/out 할 때 최소로 조정할 수 있는 instance 개수 (1 ~ 10,000) default: 1
    status                         = string           # ECS가 ASG의 scale in/out 관리 (ENABLED, DISABLED)
    target_capacity                = optional(number) # Capacity Provider Reservation 매트릭 목표 수치 (1 ~ 100) default: 100%
    instance_warmup_period         = optional(number) # 새로운 instance가 시작됐을 때 CloudWatch 매트릭에 반영되기까지의 시간 (sec)
  }))
  default = null
}

variable "enabled_fargate_cas" {
  description = "FARGATE, FARGATE_SPOT capacity provider 활성화 여부"
  type        = bool
  default     = false
}
