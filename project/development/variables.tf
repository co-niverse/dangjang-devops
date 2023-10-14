### Common
variable "availability_zones" {
  type = list(string)
}

variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}

### Kinesis
variable "log_shard_count" {
  type = number
}

variable "notification_shard_count" {
  type = number
}

### OpenSearch
variable "instance_type" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "volume_size" {
  type = number
}

variable "master_user_name" {
  type = string
}

variable "master_user_password" {
  type = string
}

### Lambda (Notification)
variable "notification_lambda_role_name" {
  type = string
}

variable "notification_function_dir_path" {
  type = string
}

variable "notification_function_zip_path" {
  type = string
}

variable "notification_handler" {
  type = string
}

variable "notification_environment" {
  type = map(string)
}

variable "fcm_layer_name" {
  type = string
}