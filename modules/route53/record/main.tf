resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.alias == null ? var.ttl : null
  records = var.alias == null ? var.records : null

  dynamic "alias" {
    for_each = var.alias != null ? [1] : []
    content {
      name                   = var.alias.name
      zone_id                = var.alias.zone_id
      evaluate_target_health = var.alias.evaluate_target_health
    }
  }
}
