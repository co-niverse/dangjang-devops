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