###################
#       EC2       #
###################

variable "env" {
  type = string
}

variable "mongo_instance_type" {
  type = string
}

variable "private_db_subnets" {
  type = list(string)
}

variable "mongo_security_group_id" {
  type = string
}

variable "public_bastion_subnet" {
  type = string
}

variable "bastion_security_group_id" {
  type = string
}