module "s3" {
  source = "../../modules/s3"

  env = var.env
}

module "ecr" {
  source = "../../modules/ecr"

  env = var.env
}

module "kinesis" {
  source = "../../modules/kinesis"

  env                      = var.env
  log_shard_count          = var.log_shard_count
  notification_shard_count = var.notification_shard_count
}

module "firehose" {
  source = "../../modules/firehose"

  env                    = var.env
  client_log_kinesis_arn = module.kinesis.client_log_arn
  client_log_bucket_arn  = module.s3.client_log_arn
  server_log_kinesis_arn = module.kinesis.server_log_arn
  server_log_bucket_arn  = module.s3.server_log_arn
  log_opensearch_arn     = module.opensearch.log_opensearch_arn
}

module "opensearch" {
  source = "../../modules/opensearch"

  env                  = var.env
  instance_type        = var.instance_type
  instance_count       = var.instance_count
  volume_size          = var.volume_size
  master_user_name     = var.master_user_name
  master_user_password = var.master_user_password
}

module "notification_lambda" {
  source = "../../modules/lambda"

  role_name              = var.notification_lambda_role_name
  dir                    = true
  dir_path               = var.notification_function_dir_path
  zip_path               = var.notification_function_zip_path
  function_name          = "notification-lambda-${var.env}"
  handler_name           = var.notification_handler
  environment            = var.notification_environment
  layer_names             = [var.fcm_layer_name]
  create_kinesis_trigger = true
  kinesis_arn            = module.kinesis.notification_arn
}

module "notification_lambda_log_goup" {
  source = "../../modules/cloudwatch"

  log_group_name = "/aws/lambda/${module.notification_lambda.function_name}"
  retention_days = 1
}
