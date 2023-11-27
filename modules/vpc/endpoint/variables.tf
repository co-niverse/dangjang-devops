variable "create_gateway" {
  description = "gateway endpoint 생성 여부"
  type = bool
  default = false
}

variable "create_interface" {
  description = "interface endpoint 생성 여부"
  type = bool
  default = false
}

variable "vpc_id" {
  description = "연결할 vpc id"
  type = string
}

variable "service_name" {
  description = "연결할 서비스 이름 ex) com.amazon.{region}.{service}"
  type = string
}

variable "route_table_ids" {
  description = "route table ids for gateway endpoint"
  type = list(string)
  default = [ ]
}

variable "subnet_ids" {
  description = "subnet ids for interface endpoint"
  type = list(string)
  default = [ ]
}

variable "endpoint_name" {
  description = "endpoint 이름"
  type = string
}