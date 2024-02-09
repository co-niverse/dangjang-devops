variable "ami" {
  description = "AMI ID (default: Ubuntu 22.04-arm64 LTS)"
  type        = string
  default     = "ami-00fdfe418c69b624a"
}

variable "instance_type" {
  description = "인스턴스 타입"
  type = string
}

variable "key_name" {
  description = "SSH key-pair name"
  type        = string
}

variable "pulic_ip_enabled" {
  description = "Public IP 할당 여부"
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "할당할 Subnet ID"
  type        = string
}

variable "security_group_ids" {
  description = "할당할 Security Group ID"
  type        = list(string)
}

variable "source_dest_check" {
  description = "소스/대상 확인 여부"
  type        = bool
  default     = true
}

variable "delete_on_termination" {
  description = "인스턴스 삭제 시 EBS 볼륨 삭제 여부"
  type        = bool
  default     = true
}

variable "volume_type" {
  description = "EBS 볼륨 타입"
  type        = string
  default     = "gp3"
}

variable "volume_size" {
  description = "EBS 볼륨 크기"
  type        = number
  default     = 8
}

variable "ebs_name" {
  description = "EBS 볼륨 이름"
  type        = string
}

variable "instance_name" {
  description = "인스턴스 이름"
  type        = string
}
