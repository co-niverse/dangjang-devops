###################
#       RDS       #
###################

variable "env" {
  type = string
}

variable "storage_size" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "multi_az" {
  type = bool
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "create_replica" {
  type = bool
}

variable "create_snapshot" {
  type = bool
}

variable "security_group_id" {
  type = string
}

variable "private_db_subnets" {
  type = list(string)
}
