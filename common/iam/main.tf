module "vpc_flow_log_role" {
  source    = "../module/iam-role"
  role_name = "vpc-flow-log-role"
  services = [
    "vpc-flow-logs.amazonaws.com"
  ]
  role_policy_arns = [
    module.vpc_flow_log_policy.arn
  ]
}

module "vpc_flow_log_policy" {
  source           = "../module/iam-policy"
  policy_name = "vpc-flow-log-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}
