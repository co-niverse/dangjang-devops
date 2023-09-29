###################
#    Firehose     #
###################

variable "env" {
  type = string
}

variable "client_log_kinesis_arn" {
  type = string
}

variable "client_log_bucket_arn" {
  type = string
}

variable "server_log_kinesis_arn" {
  type = string
}

variable "server_log_bucket_arn" {
  type = string
}

variable "log_opensearch_arn" {
  type = string
}
