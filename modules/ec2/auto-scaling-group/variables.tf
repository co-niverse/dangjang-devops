variable "name" {
  description = "ASG name"
  type        = string
}

variable "desired_capacity" {
  description = "실행해야 하는 instance 개수"
  type        = number
}

variable "max_size" {
  description = "instance 최대 개수"
  type        = number
}

variable "min_size" {
  description = "instance 최소 개수"
  type        = number
}

variable "vpc_zone_identifier" {
  description = "subnet ids"
  type        = list(string)
}

variable "health_check_grace_period" {
  description = "instance 생성 후 health check까지 대기 시간 (sec)"
  type        = number
  default     = 300
}

variable "health_check_type" {
  description = "health check 방식 (EC2, ELB)"
  type        = string
  default     = "EC2"
}

variable "protect_from_scale_in" {
  description = "새로 시작된 instance가 scale in 대상에서 보호되는지 여부"
  type        = bool
  default     = true
}

variable "metrics_granularity" {
  description = "metrics 수집 주기 - hasicorp/aws/v5.29.0 기준 1Minute만 지원"
  type        = string
  default     = "1Minute"
}

variable "metrics" {
  description = "수집할 metrics"
  type        = list(string)
  default     = null
}

variable "launch_template_id" {
  description = "launch template id"
  type        = string
}

variable "launch_template_version" {
  description = "launch template version ($Latest, $Default)"
  type        = string
  default     = "$Latest"
}

variable "instance_refresh_strategy" {
  description = "instance 교체 시 배포 전략 - hasicorp/aws/v5.29.0 기준 Rolling만 지원"
  type        = string
  default     = "Rolling"
}

variable "propagate_at_launch" {
  description = "instance 생성 시 tag 전파 여부"
  type        = bool
  default     = true
}
