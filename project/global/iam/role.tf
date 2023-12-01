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

module "ecs_task_role" {
  source = "../../../modules/iam-role"
  role_name = "ecs-task-role"
  services = [
    "ecs-tasks.amazonaws.com"
  ]
  role_policy_arns = [
    module.ecs_task_policy.arn,
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]
}

module "ecs_task_execution_role" {
  source = "../../../modules/iam-role"
  role_name = "ecs-task-execution-role"
  services = [
    "ecs-tasks.amazonaws.com"
  ]
  role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

module "firehose_role" {
  source    = "../../../modules/iam-role"
  role_name = "firehose-role"
  services = [
    "firehose.amazonaws.com"
  ]
  role_policy_arns = [
    module.s3_policy.arn,
    module.kinesis_policy.arn,
    module.log_group_policy.arn,
    module.opensearch_policy.arn
  ]
}

module "ecs_ec2_role" {
  source    = "../../../modules/iam-role"
  role_name = "ecs-ec2-role"
  services = [
    "ec2.amazonaws.com",
    "ecs.amazonaws.com"
  ]
  role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  ]
}