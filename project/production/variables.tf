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

### ELB
variable "acm_domain" {
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

### EC2
variable "mongo_instance_type" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

### RDS
variable "rds_storage_size" {
  type = number
}

variable "rds_instance_type" {
  type = string
}

variable "rds_username" {
  type = string
}

variable "rds_password" {
  type = string
}


### Lambda
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

### ElastiCache
variable "node_type" {
  type = string
}

variable "num_cache_clusters" {
  type = number
}

variable "user_id" {
  type = string
}

variable "user_name" {
  type = string
}
  
variable "passwords" {
  type = list(string)
}
