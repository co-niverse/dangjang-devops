###################
#     Lambda      #
###################

# notification lambda role
module "notification_lambda_role" {
  source    = "../../common/module/iam-role"
  role_name = "notification-lambda-role-${var.env}"
  services = [
    "lambda.amazonaws.com"
  ]
  role_policy_arns = [
    module.notification_lambda_policy.arn
  ]
}

# notification lambda policy
module "notification_lambda_policy" {
  source      = "../../common/module/iam-policy"
  policy_name = "notification-lambda-policy-${var.env}"
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
      },
      {
        Effect = "Allow"
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:DescribeStreamSummary",
          "kinesis:ListShards",
          "kinesis:ListStreams",
          "kinesis:SubscribeToShard"
        ]
        Resource = "*"
      }
    ]
  })
}
