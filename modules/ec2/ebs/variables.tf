variable "availability_zone" {
  description = "가용 영역"
  type        = string
}

variable "size" {
  description = "EBS 볼륨 크기"
  type        = number
  default     = 8
}

variable "type" {
  description = "EBS 볼륨 타입"
  type        = string
  default     = "gp3"
}

variable "final_snapshot" {
  description = "EBS 볼륨이 삭제될 때 최종 스냅샷 생성 여부"
  type        = bool
  default     = false
}

variable "name" {
  description = "EBS 볼륨 이름"
  type        = string
}

variable "device_name" {
  description = "마운트할 디바이스 이름"
  type        = string
  default     = "/dev/sdf"
}

variable "instance_id" {
  description = "EBS 볼륨을 연결할 EC2 인스턴스 id"
  type        = string
}
