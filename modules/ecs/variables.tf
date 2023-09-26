###################
#       ECS       #
###################

variable "env" {
  type = string
}

variable "app_security_group" {
  type = string
}

variable "elb_target_group_arn" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "private_subnets" {
  type = list(string)
}

variable "container_cpu" {
  type = number
}

variable "container_memory" {
  type = number
}