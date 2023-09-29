###################
#    Firehose     #
###################

resource "aws_iam_role" "firehose_role" {
  name = "firehose-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

### S3 policy
resource "aws_iam_policy" "firehose_s3" {
  name = "firehose-s3-policy-${var.env}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucketMultipartUploads",
          "s3:AbortMultipartUpload",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:PutObject"
        ],
        Resource = [
          "${var.client_log_bucket_arn}",
          "${var.client_log_bucket_arn}/*",
          "${var.server_log_bucket_arn}",
          "${var.server_log_bucket_arn}/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_s3" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_s3.arn
}


### OpenSearch policy
resource "aws_iam_policy" "firehose_opensearch" {
  name = "firehose-opensearch-policy-${var.env}"
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
          "es:ESHttpPut"
        ],
        Resource = [
          "${var.log_opensearch_arn}",
          "${var.log_opensearch_arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "es:ESHttpGet"
        ],
        Resource = [
          "${var.log_opensearch_arn}/_all/_settings",
          "${var.log_opensearch_arn}/_cluster/stats",
          "${var.log_opensearch_arn}/*-log/_mapping/_doc",
          "${var.log_opensearch_arn}/_nodes",
          "${var.log_opensearch_arn}/_nodes/stats",
          "${var.log_opensearch_arn}/_nodes/*/stats",
          "${var.log_opensearch_arn}/_stats",
          "${var.log_opensearch_arn}/*-log/_stats"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_opensearch" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_opensearch.arn
}


### Kinesis policy
resource "aws_iam_policy" "firehose_kinesis" {
  name = "firehose-kinesis-policy-${var.env}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ],
        Resource = [
          "${var.client_log_kinesis_arn}",
          "${var.server_log_kinesis_arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_kinesis" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_kinesis.arn
}


### Put record policy
resource "aws_iam_policy" "put_record" {
  name = "firehose-put-record-policy-${var.env}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ],
        Resource = [
          "${aws_kinesis_firehose_delivery_stream.client_log_s3_stream.arn}",
          "${aws_kinesis_firehose_delivery_stream.client_log_opensearch_stream.arn}",
          "${aws_kinesis_firehose_delivery_stream.server_log_s3_stream.arn}",
          "${aws_kinesis_firehose_delivery_stream.server_log_opensearch_stream.arn}",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "put_record" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.put_record.arn
}
