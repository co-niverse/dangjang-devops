###################
#       ELB       #
###################

variable "elb_name" {
  description = "로드밸런서 이름"
  type        = string
}

variable "internal" {
  description = "내부 로드밸런서 여부"
  type        = bool
  default = false
}

variable "load_balancer_type" {
  description = "로드밸런서 타입 (application, gateway, network)"
  type        = string
  default     = "application"
}

variable "security_groups" {
  description = "로드밸런서 보안그룹"
  type = list(string)
}

variable "subnets" {
  description = "로드밸런서 서브넷"
  type = list(string)
}

variable "target_group_name" {
  description = "타겟 그룹 이름"
  type        = string
}

variable "target_type" {
  description = "타겟 그룹의 유형 (instance, ip, lambda, alb)"
  type        = string
  default     = "ip"
}

  
variable "target_port" {
  description = "타겟 그룹이 수신하는 포트"
  type        = number
}

variable "target_protocol" {
  description = "타겟 그룹에게 라우팅할 때 사용하는 프로토콜"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "타겟 그룹을 생성할 VPC ID (required when target_type is instance, ip, alb)"
  type = string
}

variable "health_check_port" {
  description = "상태 확인에 사용할 포트"
  type        = number
}

variable "interval" {
  description = "상태 확인 주기(sec)"
  type        = number
  default = 300
}

variable "ping_path" {
  description = "ping 경로"
  type        = string
}

variable "matcher" {
  description = "상태 확인 성공 코드"
  type        = string
  default     = "200"
}
  
variable "healthy_threshold" {
  description = "정상 간주 성공 횟수"
  type        = number
  default = 2
}

variable "unhealthy_threshold" {
  description = "비정상 간주 실패 횟수"
  type        = number
  default = 2
}

variable "listener_port" {
  description = "로드밸런서가 수신하는 포트"
  type        = number
  default     = 443
}

variable "listener_protocol" {
  description = "로드밸런서가 수신하는 프로토콜"
  type        = string
  default     = "HTTPS"
}

variable "ssl_policy" {
  description = "SSL 정책"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "certificate_domain" {
  description = "연결할 도메인 인증서"
  type = string
}
