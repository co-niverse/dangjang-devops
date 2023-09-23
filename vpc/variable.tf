variable "availability_zones" {
  type = list(string)
}

variable "aws_region" {
  type = string
}

variable "vpc_name" {
  type    = string
  default = "dangjang"
}

variable "cidr_numeral" {
  type    = string
  default = "0"
}

variable "cidr_numeral_public" {
  type = map(string)
  default = {
    "0" = "0"
    "1" = "16"
    "2" = "32"
  }
}

variable "cidr_numeral_private" {
  type = map(string)
  default = {
    "0" = "48"
    "1" = "64"
    "2" = "80"
  }
}

variable "cidr_numeral_private_db" {
  type = map(string)
  default = {
    "0" = "96"
    "1" = "112"
    "2" = "128"
  }
}
