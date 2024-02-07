module "dynamodb" {
  source = "./dynamodb"
}

module "s3" {
  source = "./s3"
}

module "iam" {
  source = "./iam"
}

module "lambda_layer" {
  source = "./lambda_layer"
}

# data "aws_route53_zone" "default" {
#   name = "${var.domain}"
# }

# data "aws_route53_zone" "dev" {
#   name = "dev.${var.domain}"
# }

# module "subdomain_dev" {
#   source = "../../modules/route53/record"

#   zone_id = data.aws_route53_zone.default.zone_id
#   name    = "dev.${var.domain}"
#   type    = "NS"
#   ttl     = 172800
#   records = data.aws_route53_zone.dev.name_servers
# }

# data "aws_route53_zone" "staging" {
#   name = "staging.${var.domain}"
# }

# module "subdomain_staging" {
#   source = "../../modules/route53/record"

#   zone_id = data.aws_route53_zone.default.zone_id
#   name    = "staging.${var.domain}"
#   type    = "NS"
#   ttl     = 172800
#   records = data.aws_route53_zone.staging.name_servers
# }