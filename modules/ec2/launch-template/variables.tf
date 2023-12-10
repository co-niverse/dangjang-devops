variable "ecs_cluster_name" {
  description = "ECS 클러스터 이름"
  type        = string
}

variable "ec2_role_name" {
  description = "EC2 역할 이름"
  type        = string
}

variable "profile_name" {
  description = "인스턴스 프로파일 이름 (IAM 역할을 EC2 인스턴스에 연결)"
  type        = string
}

variable "template_name" {
  description = "시작 템플릿 이름"
  type        = string
}

variable "image_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "인스턴스 타입"
  type        = string
}

variable "key_name" {
  description = "SSH key-pair name"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "할당할 Security Group ID"
  type        = list(string)
  default     = null
}

variable "device_name" {
  description = "마운트할 디바이스 이름"
  type        = string
  default     = "/dev/xvda"
}

variable "volume_type" {
  description = "EBS 볼륨 타입"
  type        = string
  default     = "gp3"
}

variable "volume_size" {
  description = "EBS 볼륨 크기"
  type        = number
  default     = 30
}

variable "enabled_monitoring" {
  description = "모니터링 활성화 여부"
  type        = bool
  default     = false
}

variable "ebs_tag_name" {
  description = "EBS 볼륨 태그 이름"
  type        = string
}
