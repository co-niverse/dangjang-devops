variable "domain_name" {
  description = "도메인 이름"
  type        = string
}

variable "validation_method" {
  description = "인증 방법: DNS 또는 EMAIL"
  type        = string
  default     = "DNS"
}

variable "subject_alternative_names" {
  description = "대체 도메인 이름 목록"
  type        = list(string)
  default     = null
}