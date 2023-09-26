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

### VPC
variable "cidr_numeral" {
  type    = string
}

variable "cidr_numeral_public" {
  type = map(string)
}

variable "cidr_numeral_private" {
  type = map(string)
}

variable "cidr_numeral_private_db" {
  type = map(string)
}

### Route53
variable "domain" {
  type = string
}

### ECS
variable "desired_count" {
  type = number
}

variable "container_cpu" {
  type = number
}

variable "container_memory" {
  type = number
}

### Kinesis
variable "shard_count" {
  type = number
}

### Firehose
variable "client_log_opensearch_stream_name" {
  type = string
}

variable "server_log_opensearch_stream_name" {
  type = string
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