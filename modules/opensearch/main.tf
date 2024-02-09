resource "aws_opensearch_domain" "opensearch" {
  domain_name    = var.name
  engine_version = var.engine_version

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_size = var.volume_size
  }

  advanced_security_options {
    enabled                        = var.advanced_security_options_enabled
    internal_user_database_enabled = var.internal_user_database_enabled
    master_user_options {
      master_user_name     = var.master_user_name
      master_user_password = var.master_user_password
    }
  }

  encrypt_at_rest {
    enabled = var.encrypt_at_rest_enabled
  }

  domain_endpoint_options {
    enforce_https       = var.enforce_https
    tls_security_policy = var.tls_security_policy
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }
}

# 도메인 액세스 정책
resource "aws_opensearch_domain_policy" "opensearch" {
  domain_name = aws_opensearch_domain.opensearch.domain_name
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
        Resource = "${aws_opensearch_domain.opensearch.arn}/*"
      }
    ]
  })
}
