variable "name" {
  description = "firehose 이름"
  type        = string
}

variable "destination" {
  description = "목적지 (extended_s3, opensearch, ...)"
  type        = string
}

variable "kinesis_stream_arn" {
  description = "kinesis stream arn"
  type        = string
}

variable "configuration" {
  description = "dynamic 설정"
  type = map(object({
    bucket_arn         = string
    buffering_interval = number
    domain_arn         = optional(string)
    index_name         = optional(string)
    s3_backup_mode     = optional(string)
  }))
}
