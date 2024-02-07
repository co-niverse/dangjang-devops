variable "domain" {
  description = "도메인 이름"
  type        = string
}

variable "vpc_id" {
  description = "private zone일 경우 하나 이상의 vpc를 연결해야 함"
  type        = string
  default     = null
}
