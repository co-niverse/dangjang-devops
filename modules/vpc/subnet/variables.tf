variable "vpc_id" {
  description = "연결할 vpc id"
  type        = string
}

variable "vpc_cidr_numeral" {
  description = "VPC CIDR 넘버"
  type        = string
}

variable "subnets" {
  description = "서브넷 CIDR 넘버, 가용 영역"
  type = map(object({
    numeral           = number
    availability_zone = string
  }))
}

variable "map_public_ip_on_launch" {
  description = "public ip 할당 여부"
  type        = bool
  default     = false
}

variable "route_table_name" {
  description = "라우트 테이블 이름"
  type        = string
}

variable "destination_cidr_block" {
  description = "라우트 대상 CIDR 블록"
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_igw_destination" {
  description = "인터넷 게이트웨이 목적지 연결 여부"
  type        = bool
  default     = false
}

variable "igw_id" {
  description = "인터넷 게이트웨이 id"
  type        = string
  default     = null
}

variable "enable_nat_destination" {
  description = "NAT 게이트웨이 목적지 연결 여부"
  type        = bool
  default     = false
}

variable "nat_gateway_id" {
  description = "NAT 게이트웨이 id"
  type        = string
  default     = null
}

variable "enable_vpc_endpoint_destination" {
  description = "VPC 엔드포인트 목적지 연결 여부"
  type        = bool
  default     = false
}

variable "vpc_endpoint_id" {
  description = "VPC 엔드포인트 id"
  type        = string
  default     = null
}
