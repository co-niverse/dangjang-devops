###################
#   ElastiCache   #
###################

variable "group_id" {
  description = "replica 그룹 ID"
  type        = string
}

variable "multi_az_enabled" {
  description = "멀티 AZ 활성화 (true면 failover_eanbled도 true, replica 최소 1개 이상)"
  type        = bool
  default     = false
}

variable "failover_enabled" {
  description = "자동 장애 조치 (읽기 복제본 승격)"
  type        = bool
  default     = false
}

variable "preffered_cluster_azs" {
  description = "선호하는 클러스터 가용 영역 (size가 num_cache_clusters와 같아야 함)"
  type        = list(string)
}

variable "node_type" {
  description = "클러스터 타입"
  type        = string
}

variable "num_cache_clusters" {
  description = "클러스터 개수"
  type        = number
}

variable "engine" {
  description = "엔진: redis, memcached"
  type        = string
  default     = "redis"
}

variable "engine_version" {
  description = "엔진 버전"
  type        = string
  default     = "7.0"
}

variable "parameter_group_name" {
  description = "파라미터 그룹"
  type        = string
  default     = "default.redis7"
}

variable "port" {
  description = "포트 번호"
  type        = number
  default     = 6379
}

variable "security_group_ids" {
  description = "적용할 보안 그룹 ID"
  type        = list(string)
}

variable "auto_minor_version_upgrade" {
  description = "마이너 버전 엔진 업그레이드 자동 적용"
  type        = bool
  default     = false
}

variable "subnet_group_name" {
  description = "서브넷 그룹 이름"
  type        = string
}

variable "subnet_ids" {
  description = "할당할 서브넷 ID"
  type        = list(string)
}

variable "user_id" {
  description = "elasticache 유저 ID"
  type        = string
}

variable "user_name" {
  description = "elasticache 유저 이름"
  type        = string
}

variable "access_string" {
  description = "접근 권한"
  type        = string
  default     = "on ~* +@all"
}

variable "passwords" {
  description = "elasticache 유저 비밀번호"
  type        = list(string)
}

variable "create_user" {
  description = "유저 생성 여부"
  type        = bool
  default     = false
}
