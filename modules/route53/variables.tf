###################
#     Route53     #
###################

variable "create_private_zone" {
  type = bool
}

variable "vpc_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "mongo_private_ip" {
  type = string
}

variable "rds_endpoint" {
  type = string
}

variable "api_dns_name" {
  type = string
}

variable "api_zone_id" {
  type = string
}
