variable "role_name" {
  type = string
}

variable "services" {
  type = list(string)
}
  
variable "role_policy_arns" {
  type = list(string)
}
