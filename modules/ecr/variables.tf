###################
#       ECR       #
###################

variable "env" {
  type = string
}

variable "force_delete" {
  type = bool
  default = true
}