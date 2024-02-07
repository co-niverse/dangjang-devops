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

variable "users" {
  type = list(string)
}

### VPC
variable "cidr_numeral" {
  type = string
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

variable "app_container_port" {
  type = number
}

variable "app_container_health_check_port" {
  type = number
}

variable "app_container_name" {
  type = string
}

variable "fluentbit_container_port" {
  type = number
}

variable "fluentbit_container_name" {
  type = string
}

### OpenSearch
variable "instance_type" {
  type = string
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
variable "notification_environment" {
  type = map(string)
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

### Launch Template
variable "launch_template_instance_type" {
  type = string
}