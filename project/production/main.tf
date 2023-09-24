module "vpc" {
  source = "../../modules/vpc"

  availability_zones      = var.availability_zones
  aws_region              = var.aws_region
  cidr_numeral            = var.cidr_numeral
  cidr_numeral_public     = var.cidr_numeral_public
  cidr_numeral_private    = var.cidr_numeral_private
  cidr_numeral_private_db = var.cidr_numeral_private_db
  env                     = var.env
  # elb = module
}

module "s3" {
  source = "../../modules/s3"

  env = var.env
}

module "ecr" {
  source = "../../modules/ecr"

  env = var.env
}

# module "ecs" {
#   source = "../../modules/ecs"

#   env                  = var.env
#   app_security_group   = module.vpc.app_sg
#   elb_target_group_arn = module.elb.elb_target_group_arn
# }

module "elb" {
  source = "../../modules/elb"

  env            = var.env
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  default_sg     = module.vpc.default_sg
  domain         = var.domain
}

module "route53" {
  source = "../../modules/route53"

  domain = var.domain
  api_dns_name = module.elb.elb_dns_name
  api_zone_id = module.elb.elb_zone_id
}
