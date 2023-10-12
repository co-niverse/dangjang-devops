###################
#     Kinesis     #
###################

variable "env" {
  type = string
}

variable "log_shard_count" {
  type = number
}

variable "notification_shard_count" {
  type = number
}