###################
#     Lambda      #
###################

# 변경사항 압축 파일 생성
data "archive_file" "init" {
  type        = "zip"
  source_file = var.file_path
  output_path = var.zip_path
}

# notification lambda 생성
resource "aws_lambda_function" "notification" {
  function_name    = "notification-lambda-${var.env}"           # 람다 함수명
  role             = module.notification_lambda_role.arn        # 람다 함수가 사용할 역할
  handler          = "notification.lambda_handler"              # 람다 함수의 핸들러
  runtime          = "python3.11"                               # 런타임
  architectures    = ["arm64"]                                  # 아키텍처
  filename         = var.zip_path                               # 함수 코드가 들어있는 zip 파일명
  source_code_hash = data.archive_file.init.output_base64sha256 # zip 파일의 sha256 해시값
  timeout          = 60                                         # 함수 실행 제한 시간 (sec)
  memory_size      = 128                                        # 런타임 중 할당되는 메모리 크기
  # layers = []                                                  # 람다 레이어 추가

  environment {
    variables = {
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# notification lambda trigger 생성 (kinesis stream)
resource "aws_lambda_event_source_mapping" "notification" {
  event_source_arn  = var.notification_kinesis_arn         # kinesis stream arn
  function_name     = aws_lambda_function.notification.arn # lambda arn
  starting_position = "LATEST"
}

# resource "aws_lambda_layer_version" "layer" {

# }
