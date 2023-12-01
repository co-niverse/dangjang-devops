variable "key_name" {
  description = "EC2 인스턴스에 사용할 키페어 이름"
  type        = string
}

variable "public_key_path" {
  description = "EC2 인스턴스에 사용할 키페어 공개키 경로"
  type        = string
}