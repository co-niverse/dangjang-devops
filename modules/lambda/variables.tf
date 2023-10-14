###################
#     Lambda      #
###################

variable "dir" {
  type = bool
  default = false
}

variable "dir_path" {
  type = string
  default = ""
}

variable "file_path" {
  type = string
  default = ""
}
  
variable "zip_path" {
  type = string
}

variable "env" {
  type = string
}

variable "function_name" {
  type = string
}

variable "handler_name" {
  type = string
}

variable "runtime" {
  type = string
  default = "python3.11"
}
  
variable "architectures" {
  type = list(string)
  default = ["arm64"]
}

variable "timeout" {
  type = number
  default = 60
}
  
variable "memory_size" {
  type = number
  default = 128
}

variable "environment" {
  type = map(string)
  default = { }
}

variable "layer_arns" {
  type = list(string)
  default = [ ]
}

variable "create_kinesis_trigger" {
  type = bool
  default = false
}

variable "kinesis_arn" {
  type = string
  default = ""
}