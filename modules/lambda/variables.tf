###################
#     Lambda      #
###################

variable "env" {
  type = string
}

variable "notification_kinesis_arn" {
  type = string
}

variable "file_path" {
  type = string
}
  
variable "zip_path" {
  type = string
}