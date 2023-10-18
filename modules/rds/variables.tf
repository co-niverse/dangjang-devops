###################
#       RDS       #
###################

variable "env" {
  description = "환경"
  type = string
}

variable "primary_instance_name" {
  description = "RDS primary 이름"
  type = string
}

variable "replica_instance_name" {
  description = "RDS replica 이름"
  type = string
}

variable "snapshot_name" {
  description = "RDS snapshot 이름"
  type = string
}

variable "db_subnet_group_name" {
  description = "RDS DB subnet group 이름"
  type = string
}
  
variable "db_parameter_group_name" {
  description = "RDS DB parameter group 이름"
  type = string
}

variable "storage_size" {
  description = "할당할 스토리지 크기"
  type = number
}

variable "engine" {
  description = "RDS 엔진"
  type = string
  default = "mysql"
}
  
variable "engine_version" {
  description = "RDS 엔진 버전"
  type = string
  default = "8.0.33"
}

variable "instance_type" {
  description = "RDS 인스턴스 타입"
  type = string
}

variable "stoarge_type" {
  description = "RDS 스토리지 타입"
  type = string
  default = "gp3"  
}

variable "multi_az" {
  description = "멀티 AZ 여부"
  type = bool
}

variable "username" {
  description = "RDS 인스턴스에 접속할 유저 이름"
  type = string
}

variable "password" {
  description = "RDS 인스턴스에 접속할 유저 비밀번호"
  type = string
}

variable "backup_retention_period" {
  description = "백업 보존 기간"
  type = number
  default = 7
}

variable "skip_final_snapshot" {
  description = "삭제 시 최종 스냅샷 스킵 여부"
  type = bool
  default = true
}
  
variable "apply_immediately" {
  description = "변경 사항 즉시 적용 여부"
  type = bool
  default = true
}


variable "create_replica" {
  description = "read replica 생성 여부"
  type = bool
}

variable "create_snapshot" {
  description = "스냅샷 생성 여부"
  type = bool
}

variable "security_group_id" {
  description = "RDS 인스턴스에 적용할 보안 그룹 ID"
  type = string
}

variable "private_db_subnets" {
  description = "RDS 인스턴스에 적용할 private subnet ID"
  type = list(string)
}

variable "db_parameter_family" {
  description = "RDS DB parameter family"
  type = string
  default = "mysql8.0"
}
