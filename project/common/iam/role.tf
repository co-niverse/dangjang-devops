module "vpc_flow_log_role" {
  source    = "../../../modules/iam-role"
  role_name = "vpc-flow-log-role"
  services = [
    "vpc-flow-logs.amazonaws.com"
  ]
  role_policy_arns = [
    module.log_group_policy.arn
  ]
}

module "notification_lambda_role" {
  source    = "../../../modules/iam-role"
  role_name = "notification-lambda-role"
  services = [
    "lambda.amazonaws.com"
  ]
  role_policy_arns = [
    module.log_group_policy.arn,
    module.kinesis_policy.arn
  ]
}
