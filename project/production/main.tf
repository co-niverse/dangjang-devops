module "network" {
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
#   source = "./ecs"
# }

# module "elb" {
#   source             = "../../modules/elb"
#   availability_zones = var.availability_zones
#   aws_region         = var.aws_region
# }
