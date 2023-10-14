###################
#    CloudWatch   #
###################

variable "log_group_name" {
  type = string
}

variable "retention_days" {
  default = 7
  type = number
}