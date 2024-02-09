# Firehose role
data "aws_iam_role" "firehose" {
  name = "firehose-role"
}

# Firehose
resource "aws_kinesis_firehose_delivery_stream" "stream" {
  name        = var.name
  destination = var.destination

  kinesis_source_configuration {
    role_arn           = data.aws_iam_role.firehose.arn
    kinesis_stream_arn = var.kinesis_stream_arn
  }

  dynamic "extended_s3_configuration" {
    for_each = var.destination == "extended_s3" ? var.configuration : {}
    content {
      role_arn           = data.aws_iam_role.firehose.arn
      bucket_arn         = extended_s3_configuration.value.bucket_arn
      buffering_interval = extended_s3_configuration.value.buffering_interval
    }
  }

  dynamic "opensearch_configuration" {
    for_each = var.destination == "opensearch" ? var.configuration : {}
    content {
      role_arn           = data.aws_iam_role.firehose.arn
      domain_arn         = opensearch_configuration.value.domain_arn
      index_name         = opensearch_configuration.value.index_name
      buffering_interval = opensearch_configuration.value.buffering_interval
      s3_backup_mode     = opensearch_configuration.value.s3_backup_mode

      s3_configuration {
        role_arn   = data.aws_iam_role.firehose.arn
        bucket_arn = opensearch_configuration.value.bucket_arn
      }
    }
  }
}
