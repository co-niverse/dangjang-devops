variable "domain" {
  type = string
}

variable "env" {
  type = string  
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "default_sg" {
  type = string
}