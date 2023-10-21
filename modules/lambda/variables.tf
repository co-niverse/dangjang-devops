###################
#     Lambda      #
###################

variable "role_name" {
  description = "Lambda function이 사용할 role 이름"
  type = string
}

variable "layer_names" {
  description = "Lambda function이 사용할 layer 이름"
  type = list(string)
  default = [ ]
}

variable "dir" {
  description = "Lambda function 코드가 파일 하나이면 false, 디렉토리면 true"
  type = bool
  default = false
}

variable "dir_path" {
  description = "Lambda function 코드가 들어있는 디렉토리 경로"
  type = string
  default = ""
}

variable "file_path" {
  description = "Lambda function 코드가 들어있는 파일 경로"
  type = string
  default = ""
}
  
variable "zip_path" {
  description = "Lambda function 코드를 압축한 후 저장할 경로"
  type = string
}

variable "function_name" {
  description = "Lambda function 이름"
  type = string
}

variable "handler_name" {
  description = "Lambda function 핸들러 이름"
  type = string
}

variable "runtime" {
  description = "Lambda function 런타임"
  type = string
  default = "python3.11"
}
  
variable "architectures" {
  description = "Lambda function 아키텍처 (arm64, x86_64)"
  type = list(string)
  default = ["arm64"]
}

variable "timeout" {
  description = "실행 제한 시간 (sec)"
  type = number
  default = 60
}
  
variable "memory_size" {
  description = "런타임 중 할당되는 메모리 크기 (MB)"
  type = number
  default = 128
}

variable "environment" {
  description = "환경 변수"
  type = map(string)
  default = { }
}

variable "maximum_event_age" {
  description = "최대 이벤트 수명 (sec)"
  type = number
  default = 21600
}

variable "maximum_retry_attempts" {
  description = "최대 재시도 횟수"
  type = number
  default = 2
}

variable "create_kinesis_trigger" {
  description = "Lambda function에 Kinesis stream trigger를 생성할지 여부"
  type = bool
  default = false
}

variable "kinesis_arn" {
  description = "Kinesis stream trigger를 생성할 때 사용할 Kinesis stream arn"
  type = string
  default = ""
}

variable "kinesis_start_position" {
  description = "Kinesis stream에서 읽기 시작할 시작 위치"
  type = string
  default = "LATEST"
}