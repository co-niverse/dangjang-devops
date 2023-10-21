###################
#       RDS       #
###################

variable "primary_instance_name" {
  description = "primary 이름"
  type        = string
}

variable "storage_size" {
  description = "할당할 스토리지 크기"
  type        = number
}

variable "engine" {
  description = "엔진"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "RDS 엔진 버전"
  type        = string
  default     = "8.0.33"
}

variable "instance_class" {
  description = "RDS 인스턴스 타입"
  type        = string
}

variable "stoarge_type" {
  description = "RDS 스토리지 타입"
  type        = string
  default     = "gp3"
}

variable "multi_az" {
  description = "다중 AZ 여부 (Active-Standby)"
  type        = bool
}

variable "username" {
  description = "RDS 인스턴스에 접속할 유저 이름"
  type        = string
}

variable "password" {
  description = "RDS 인스턴스에 접속할 유저 비밀번호"
  type        = string
}

variable "db_name" {
  description = "데이터베이스명"
  type        = string
}

variable "skip_final_snapshot" {
  description = "삭제 시 최종 스냅샷 스킵 여부"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "RDS 인스턴스에 적용할 보안 그룹 ID"
  type        = list(string)
}

variable "apply_immediately" {
  description = "변경 사항 즉시 적용 여부"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "백업 보존 기간"
  type        = number
  default     = 7
}

variable "auto_minor_version_upgrade" {
  description = "마이너 버전 엔진 업그레이드 자동 적용"
  type        = bool
  default     = false
}

variable "create_replica" {
  description = "read replica 생성 여부"
  type        = bool
}

variable "replica_instance_name" {
  description = "RDS replica 이름"
  type        = string
}

variable "create_snapshot" {
  description = "snapshot 생성 여부"
  type        = bool
}

variable "snapshot_name" {
  description = "snapshot 이름"
  type        = string
}

variable "subnet_group_name" {
  description = "subnet group 이름"
  type        = string
}

variable "subnet_ids" {
  description = "인스턴스에 적용할 subnet ID"
  type        = list(string)
}

variable "parameter_group_name" {
  description = "parameter group 이름"
  type        = string
}

variable "parameter_family" {
  description = "parameter family"
  type        = string
  default     = "mysql8.0"
}

variable "parameters" {
  description = "parameter group에 적용할 파라미터"
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))
  default = [
    {
      name         = "character_set_server"
      value        = "utf8"
      apply_method = "immediate"
    },
    {
      name         = "character_set_client"
      value        = "utf8"
      apply_method = "immediate"
    },
    {
      name         = "character_set_connection"
      value        = "utf8"
      apply_method = "immediate"
    },
    {
      name         = "character_set_database"
      value        = "utf8"
      apply_method = "immediate"
    },
    {
      name         = "character_set_results"
      value        = "utf8"
      apply_method = "immediate"
    },
    {
      name         = "time_zone"
      value        = "Asia/Seoul"
      apply_method = "immediate"
    },
    {
      name         = "collation_connection"
      value        = "utf8_general_ci"
      apply_method = "pending-reboot"
    },
    {
      name         = "collation_server"
      value        = "utf8_general_ci"
      apply_method = "pending-reboot"
    },
    {
      name         = "lower_case_table_names"
      value        = "1"
      apply_method = "pending-reboot"
    }
  ]
}
