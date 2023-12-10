resource "aws_service_discovery_http_namespace" "namespace" {
  name        = var.name
  description = var.description
  tags = {
    Name = var.name
    "AmazonECSManaged" = true
  }
}