###################
#   OpenSearch    #
###################

variable "name" {
  description = "domain 이름"
  type = string
}

variable "engine_version" {
  description = "OpenSearch 엔진 버전"
  type = string
  default = "OpenSearch_2.9"
  
}

variable "instance_type" {
  description = "노드의 인스턴스 타입"
  type = string
}

variable "instance_count" {
  description = "노드 개수"
  type = number
}

variable "ebs_enabled" {
  description = "노드에 EBS 연결 여부"
  type = bool
}

variable "volume_size" {
  description = "EBS 볼륨 크기 (GB) - 최소 10GB"
  type = number
}

variable "advanced_security_options_enabled" {
  description = "고급 보안 옵션 활성화 여부 (익명 사용자 거부) - 세분화된 엑세스 제어 활성화"
  type = bool
  default = true
}

variable "internal_user_database_enabled" {
  description = "내부 사용자 데이터베이스 활성화 여부 (true일 경우 arn방식 사용 안함)"
  type = bool
  default = true
}

variable "master_user_name" {
  description = "사용자 이름 (내부 사용자 데이터베이스 활성화 시 필요)"
  type = string
}

variable "master_user_password" {
  description = "사용자 비밀번호 (내부 사용자 데이터베이스 활성화 시 필요)"
  type = string
}

variable "encrypt_at_rest_enabled" {
  description = "디스크에 저장된(또는 유휴 상태인) 데이터 암호화 여부 (한 번 활성화하면 비활성화 불가, 세분화된 엑세스 제어 활성화시 필수)"
  type = bool
  default = true
}

variable "enforce_https" {
  description = "HTTPS 요청만 수락 (세분화된 엑세스 제어 활성화시 필수)"
  type = bool
  default = true
}

variable "tls_security_policy" {
  description = "TLS 보안 정책"
  type = string
  default = "Policy-Min-TLS-1-2-2019-07"
}

variable "node_to_node_encryption_enabled" {
  description = "노드 간 암호화 여부 (한 번 활성화하면 비활성화 불가, 세분화된 엑세스 제어 활성화시 필수)"
  type = bool
  default = true
}