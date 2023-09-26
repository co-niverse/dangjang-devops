###################
#   OpenSearch    #
###################

variable "env" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "volume_size" {
  type = number
}

variable "firehose_client_log_opensearch_name" {
  type = string
}

variable "firehose_server_log_opensearch_name" {
  type = string
}