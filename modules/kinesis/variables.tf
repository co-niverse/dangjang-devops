variable "name" {
  description = "stream 이름"
  type        = string
}

variable "shard_count" {
  description = "shard 개수 (stream mode가 PROVISIONED일 경우 필수)"
  type        = number
}

variable "retention_period" {
  description = "record 보관 기간 (hour)"
  type        = number
  default     = 24
}

variable "stream_mode" {
  description = "stream mode (PROVISIONED | ON_DEMAND)"
  type        = string
  default     = "PROVISIONED"
}
