variable "availability_zones" {
  description = "az list"
  default     = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  type        = list(string)
}

variable "aws_region" {
  default = "ap-northeast-2"
}
