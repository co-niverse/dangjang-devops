variable "create_alias" {
  description = "별칭 레코드 생성 여부 (CloudFront, S3 bucket, ELB 등에서 사용 가능) true일 경우 ttl, records 변수와 충돌함"
  type        = bool
  default     = false
}

variable "zone_id" {
  description = "레코드를 생성할 Route53 Zone ID"
  type        = string
}

variable "name" {
  description = "레코드 이름"
  type        = string
}

variable "type" {
  description = "레코드 유형 (A, CNAME, MX, NS, PTR, SOA, SPF, SRV, TXT 등)"
  type        = string
}

variable "ttl" {
  description = "TTL (Time To Live)"
  type        = number
  default     = 300
}

variable "records" {
  description = "라우팅 대상"
  type        = list(string)
  default     = []
}

variable "alias" {
  description = "별칭 레코드 생성 시 사용할 별칭 정보 (CloudFront, S3 bucket, ELB 등에서 사용 가능) ttl, records 변수와 충돌함"
  type = object({
    name                   = string # DNS domain name
    zone_id                = string # Hosted zone ID
    evaluate_target_health = bool   # Route53 health check 사용 여부
  })
  default = null
}
