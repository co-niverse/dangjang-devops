###################
#       ECR       #
###################

variable "image_count" {
  description = "보관할 이미지 개수"
  type        = number
  default     = 10
}

variable "name" {
  description = "repository 이름"
  type        = string
}

variable "image_tag_mutability" {
  description = "이미지 태그 변경 가능 여부"
  type        = string
  default     = "MUTABLE"
}

variable "force_delete" {
  description = "이미지가 존재할 때 repository 삭제 여부"
  type        = bool
  default     = true
}

variable "scan_on_push" {
  description = "push된 이미지 스캔 여부"
  type        = bool
  default     = true
}
