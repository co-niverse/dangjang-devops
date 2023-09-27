###################
#   OpenSearch    #
###################

# OpenSearch domain
resource "aws_opensearch_domain" "log_opensearch" {
  domain_name    = "os-log-${var.env}"
  engine_version = "OpenSearch_2.7"

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.volume_size
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true

    master_user_options {
      master_user_name = var.master_user_name
      master_user_password = var.master_user_password
    }
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  node_to_node_encryption {
    enabled = true
  }


  lifecycle {
    create_before_destroy = true
  }
}

data "aws_caller_identity" "current" {}

resource "aws_opensearch_domain_policy" "log_opensearch" {
  domain_name = aws_opensearch_domain.log_opensearch.domain_name
  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "es:*"
        ]
        Resource = "${aws_opensearch_domain.log_opensearch.arn}/*"
      }
    ]
  })
}

      # {
      #   Effect = "Allow"
      #   Principal = {
      #     AWS = "*"
      #   }
      #   Action = [
      #     "es:*"
      #   ]
      #   Resource = "${aws_opensearch_domain.log_opensearch.arn}/*"
      #   Condition = {
      #     ArnEquals = {
      #       "aws:SourceArn" : [
      #         "arn:aws:firehose:${var.aws_region}:${data.aws_caller_identity.current.account_id}:deliverystream/${var.firehose_client_log_opensearch_name}${var.env}",
      #         "arn:aws:firehose:${var.aws_region}:${data.aws_caller_identity.current.account_id}:deliverystream/${var.firehose_server_log_opensearch_name}${var.env}"
      #       ]
      #     }
      #   }
      # },
      # {
      #   Effect = "Allow"
      #   Principal = {
      #     AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/*"
      #   }
      #   Action = [
      #     "es:ESHttpGet"
      #   ]
      #   Resource = "${aws_opensearch_domain.log_opensearch.arn}/*"
      # }