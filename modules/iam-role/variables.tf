variable "role_name" {
  description = "role 이름"
  type = string
}

variable "services" {
  description = "role을 사용할 서비스"
  type = list(string)
}
  
variable "role_policy_arns" {
  description = "role에 연결할 policy arn"
  type = list(string)
}
