resource "aws_route53_zone" "zone" {
  name = "${var.domain}"

  dynamic "vpc" {
    for_each = var.vpc_id != null ? [1] : []
    content {
      vpc_id = var.vpc_id
    }
  }
}