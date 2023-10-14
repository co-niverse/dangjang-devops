###################
#     Lambda      #
###################

# role 가져오기
data "aws_iam_role" "lambda" {
  name = var.role_name
}

# layer 가져오기
data "aws_lambda_layer_version" "layer" {
  count      = length(var.layer_names) > 0 ? length(var.layer_names) : 0
  layer_name = var.layer_names[count.index]
}

# 변경사항 압축 파일 생성
data "archive_file" "init" {
  type = "zip"

  # dir = true이면 source_dir, 아니면 source_file
  source_dir  = var.dir ? var.dir_path : null
  source_file = var.dir ? null : var.file_path
  output_path = var.zip_path
}

# Lambda function 생성
resource "aws_lambda_function" "function" {
  function_name    = var.function_name                          # 람다 함수명
  role             = data.aws_iam_role.lambda.arn               # 람다 함수가 사용할 IAM 역할
  handler          = var.handler_name                           # 람다 함수의 핸들러명
  runtime          = var.runtime                                # 런타임
  architectures    = var.architectures                          # 아키텍처
  filename         = var.zip_path                               # 함수 코드가 들어있는 zip 파일명
  source_code_hash = data.archive_file.init.output_base64sha256 # zip 파일을 sha256로 해싱하여 업데이트 트리거
  timeout          = var.timeout                                # 함수 실행 제한 시간 (sec)
  memory_size      = var.memory_size                            # 런타임 중 할당되는 메모리 크기 (MB)
  layers           = data.aws_lambda_layer_version.layer.*.arn  # 람다 레이어 추가

  environment {
    variables = var.environment # 환경변수
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Kinesis stream trigger 생성
resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  count             = var.create_kinesis_trigger ? 1 : 0
  event_source_arn  = var.kinesis_arn                  # kinesis stream arn
  function_name     = aws_lambda_function.function.arn # function arn
  starting_position = "LATEST"                         # kinesis stream에서 읽기 시작할 위치
}
