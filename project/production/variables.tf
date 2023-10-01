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

variable "create_private_zone" {
  type = bool
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

### EC2
variable "mongo_instance_type" {
  type = string
}

### RDS
variable "rds_storage_size" {
  type = number
}

variable "rds_instance_type" {
  type = string
}

variable "rds_multi_az" {
  type = bool
}

variable "rds_username" {
  type = string
}

variable "rds_password" {
  type = string
}

variable "create_replica" {
  type = bool
}

variable "create_snapshot" {
  type = bool
}
