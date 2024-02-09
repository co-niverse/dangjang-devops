# role 가져오기
data "aws_iam_role" "lambda" {
  name = var.role_name
}

# layer 가져오기
data "aws_lambda_layer_version" "layer" {
  for_each   = toset(var.layer_names)
  layer_name = each.value
}

# 변경사항 압축 파일 생성
data "archive_file" "init" {
  type        = "zip"
  source_dir  = var.dir ? var.dir_path : null
  source_file = var.dir ? null : var.file_path
  output_path = var.zip_path
}

# Lambda function 생성
resource "aws_lambda_function" "function" {
  function_name    = var.function_name
  role             = data.aws_iam_role.lambda.arn
  handler          = var.handler_name
  runtime          = var.runtime
  architectures    = var.architectures
  filename         = var.zip_path
  source_code_hash = data.archive_file.init.output_base64sha256 # zip 파일을 sha256로 해싱하여 업데이트 트리거
  timeout          = var.timeout
  memory_size      = var.memory_size
  layers           = [for layer in data.aws_lambda_layer_version.layer : layer.arn]

  environment {
    variables = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

# 비동기식 호출
resource "aws_lambda_function_event_invoke_config" "function" {
  function_name                = aws_lambda_function.function.function_name
  maximum_event_age_in_seconds = var.maximum_event_age
  maximum_retry_attempts       = var.maximum_retry_attempts
}

# Kinesis stream trigger 생성
resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  count             = var.create_kinesis_trigger ? 1 : 0
  event_source_arn  = var.kinesis_arn
  function_name     = aws_lambda_function.function.arn
  starting_position = var.kinesis_start_position
}
