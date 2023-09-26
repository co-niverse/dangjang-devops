###################
#    Firehose     #
###################

# Client-log S3
resource "aws_kinesis_firehose_delivery_stream" "client_log_s3_stream" {
  name        = "fh-client-log-s3-stream-${var.env}"
  destination = "extended_s3"

  kinesis_source_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    kinesis_stream_arn = var.client_log_kinesis_arn
  }

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = var.client_log_bucket_arn
    buffering_interval = 60

  }
}

# Client-log OpenSearch
resource "aws_kinesis_firehose_delivery_stream" "client_log_opensearch_stream" {
  name        = "${var.client_log_opensearch_stream_name}${var.env}"
  destination = "opensearch"

  kinesis_source_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    kinesis_stream_arn = var.client_log_kinesis_arn
  }

  opensearch_configuration {
    role_arn       = aws_iam_role.firehose_role.arn
    domain_arn     = var.log_opensearch_arn
    index_name     = "client-log"
    s3_backup_mode = "FailedDocumentsOnly"

    s3_configuration {
      role_arn   = aws_iam_role.firehose_role.arn
      bucket_arn = var.client_log_bucket_arn
    }
  }
}

# Server-log S3
resource "aws_kinesis_firehose_delivery_stream" "server_log_s3_stream" {
  name        = "fh-server-log-s3-stream-${var.env}"
  destination = "extended_s3"

  kinesis_source_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    kinesis_stream_arn = var.server_log_kinesis_arn
  }

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = var.server_log_bucket_arn
    buffering_interval = 60
  }
}

# Server-log OpenSearch
resource "aws_kinesis_firehose_delivery_stream" "server_log_opensearch_stream" {
  name        = "${var.server_log_opensearch_stream_name}${var.env}"
  destination = "opensearch"

  kinesis_source_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    kinesis_stream_arn = var.server_log_kinesis_arn
  }

  opensearch_configuration {
    role_arn       = aws_iam_role.firehose_role.arn
    domain_arn     = var.log_opensearch_arn
    index_name     = "server-log"
    s3_backup_mode = "FailedDocumentsOnly"

    s3_configuration {
      role_arn   = aws_iam_role.firehose_role.arn
      bucket_arn = var.server_log_bucket_arn
    }
  }
}
