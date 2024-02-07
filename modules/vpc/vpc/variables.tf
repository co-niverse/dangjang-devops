###################
#       VPC       #
###################

variable "vpc_name" {
  description = "vpc 이름"
  type        = string
}

variable "igw_name" {
  description = "internet gateway 이름"
  type        = string
}

variable "cidr_numeral" {
  type = string
}
