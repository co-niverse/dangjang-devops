module "network" {
  source = "./vpc"

  availability_zones = var.availability_zones
  aws_region         = var.aws_region
}

module "s3" {
  source = "./s3"
}

module "ecr" {
  source = "./ecr"
}