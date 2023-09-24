###################
#       VPC       #
###################

variable "availability_zones" {
  type = list(string)
}

variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}

variable "cidr_numeral" {
  type    = string
}

variable "cidr_numeral_public" {
  type = map(string)
}

variable "cidr_numeral_private" {
  type = map(string)
}

variable "cidr_numeral_private_db" {
  type = map(string)
}

variable "elb_cidr" {
  type = string
  default = "0.0.0.0/0"
}
