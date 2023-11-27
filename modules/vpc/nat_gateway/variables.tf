variable "create_nat" {
  description = "NAT Gateway 생성 여부"
  type        = bool
  default     = false
}

variable "elastic_ip_name" {
  description = "elastic ip 이름"
  type        = string
}

variable "subnet_id" {
  description = "NAT Gateway에 할당할 subnet id"
  type        = string
}

variable "nat_gateway_name" {
  description = "NAT Gateway 이름"
  type        = string
}
