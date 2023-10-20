###################
#    CloudWatch   #
###################

variable "log_group_name" {
  description = "로그 그룹 이름"
  type        = string
}

variable "retention_days" {
  description = "로그 보존 기간"
  type        = number
  default     = 7
}