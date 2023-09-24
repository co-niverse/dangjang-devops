# resource "aws_route53_zone" "dangjang" {
#   name = "${var.domain}"
# }

# api domain
resource "aws_route53_record" "elb" {
  zone_id = data.aws_route53_zone.dangjang.zone_id
  name    = "api.${var.domain}"
  type    = "A"

  alias {
    name                   = var.api_dns_name
    zone_id                = var.api_zone_id
    evaluate_target_health = true
  }
}

data "aws_route53_zone" "dangjang" {
  name = var.domain
}