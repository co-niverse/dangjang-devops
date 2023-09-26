###################
#   OpenSearch    #
###################

data "aws_caller_identity" "current" {}

# OpenSearch policy
data "aws_iam_policy_document" "log_opensearch_policy" {
  statement {
    actions = [
      "es:*"
    ]

    resources = [
       "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/os-log-${var.env}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:firehose:${var.aws_region}:${data.aws_caller_identity.current.account_id}:deliverystream/${var.firehose_client_log_opensearch_name}${var.env}",
        "arn:aws:firehose:${var.aws_region}:${data.aws_caller_identity.current.account_id}:deliverystream/${var.firehose_server_log_opensearch_name}${var.env}"
      ]
    }
  }
}

# OpenSearch domain
resource "aws_opensearch_domain" "log_opensearch" {
  domain_name     = "os-log-${var.env}"
  engine_version  = "OpenSearch_2.7"
  access_policies = data.aws_iam_policy_document.log_opensearch_policy.json

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.volume_size
  }
}
