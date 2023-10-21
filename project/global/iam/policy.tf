module "log_group_policy" {
  source      = "../../../modules/iam-policy"
  policy_name = "dangjang-log-group-policy"
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

module "kinesis_policy" {
  source      = "../../../modules/iam-policy"
  policy_name = "dangjang-kinesis-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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

module "ecs_task_policy" {
  source      = "../../../modules/iam-policy"
  policy_name = "dangjang-ecs-task-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "kinesis:PutRecords"
        ]
        Resource = "*"
      }
    ]
  })
}

module "s3_policy" {
  source = "../../../modules/iam-policy"
  policy_name = "dangjang-s3-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        Resource = "*"
      }
    ]
  })  
}

module "opensearch_policy" {
  source = "../../../modules/iam-policy"
  policy_name = "dangjang-opensearch-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "es:DescribeDomain",
          "es:DescribeDomains",
          "es:DescribeDomainConfig",
          "es:ESHttpPost",
          "es:ESHttpPut",
          "es:ESHttpGet"
        ],
        Resource = "*"
      }
    ]
  })  
}