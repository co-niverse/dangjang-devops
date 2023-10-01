###################
#     Route53     #
###################

### private zone
resource "aws_route53_zone" "private" {
  count = "${var.create_private_zone}" ? 1 : 0
  name = "${var.domain}"

  vpc {
    vpc_id = "${var.vpc_id}"
  }
}

# mongodb domain
resource "aws_route53_record" "mongo" {
  depends_on = [ aws_route53_zone.private ]
  zone_id = aws_route53_zone.private[0].zone_id
  name = "mongo.${var.domain}"
  type = "A"
  ttl = 300
  
  records = ["${var.mongo_private_ip}"]
}

# rds domain
resource "aws_route53_record" "rds" {
  depends_on = [ aws_route53_zone.private ]
  zone_id = aws_route53_zone.private[0].zone_id
  name = "rds.${var.domain}"
  type = "CNAME"
  ttl = 300
  
  records = ["${var.rds_endpoint}"]
}


### public zone
data "aws_route53_zone" "public" {
  name = var.domain
}

# api domain
resource "aws_route53_record" "elb" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "api.${var.domain}"
  type    = "A"

  alias {
    name                   = var.api_dns_name
    zone_id                = var.api_zone_id
    evaluate_target_health = true
  }
}
