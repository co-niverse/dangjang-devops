variable "name" {
  description = "security group 이름"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "ingress" {
  description = "인바운드 규칙"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    security_groups = list(string)
  }))
}

variable "egress" {
  description = "아웃바운드 규칙"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks = list(string)
  }))
}