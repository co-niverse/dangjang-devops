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

### Lambda
variable "file_path" {
  type = string
}

variable "zip_path" {
  type = string
}