module "vpc" {
  source = "../../modules/vpc"

  availability_zones      = var.availability_zones
  aws_region              = var.aws_region
  cidr_numeral            = var.cidr_numeral
  cidr_numeral_public     = var.cidr_numeral_public
  cidr_numeral_private    = var.cidr_numeral_private
  cidr_numeral_private_db = var.cidr_numeral_private_db
  env                     = var.env
}

module "s3" {
  source = "../../modules/s3"

  env = var.env
}

module "ecr" {
  source = "../../modules/ecr"

  env = var.env
}

module "ecs" {
  source = "../../modules/ecs"

  env                      = var.env
  app_security_group       = module.vpc.app_sg
  elb_target_group_arn     = module.elb.elb_target_group_arn
  app_repository_url       = module.ecr.app_repository_url
  fluentbit_repository_url = module.ecr.fluentbit_repository_url
  desired_count            = var.desired_count
  private_subnets          = module.vpc.private_subnets
  container_cpu            = var.container_cpu
  container_memory         = var.container_memory
}

module "elb" {
  source = "../../modules/elb"

  env            = var.env
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  default_sg     = module.vpc.default_sg
  domain         = var.acm_domain
}

module "route53" {
  source = "../../modules/route53"

  create_private_zone = var.create_private_zone
  vpc_id              = module.vpc.vpc_id
  domain              = var.domain
  mongo_private_ip    = module.ec2.mongo_primary_private_ip
  rds_endpoint        = module.rds.rds_endpoint
  api_dns_name        = module.elb.elb_dns_name
  api_zone_id         = module.elb.elb_zone_id
}

module "kinesis" {
  source = "../../modules/kinesis"

  env         = var.env
  shard_count = var.shard_count
}

module "firehose" {
  source = "../../modules/firehose"

  env                    = var.env
  client_log_kinesis_arn = module.kinesis.client_log_arn
  client_log_bucket_arn  = module.s3.client_log_arn
  server_log_kinesis_arn = module.kinesis.server_log_arn
  server_log_bucket_arn  = module.s3.server_log_arn
  log_opensearch_arn     = module.opensearch.log_opensearch_arn
}

module "opensearch" {
  source = "../../modules/opensearch"

  env                  = var.env
  instance_type        = var.instance_type
  instance_count       = var.instance_count
  volume_size          = var.volume_size
  master_user_name     = var.master_user_name
  master_user_password = var.master_user_password
}

module "ec2" {
  source = "../../modules/ec2"

  env                       = var.env
  mongo_instance_type       = var.mongo_instance_type
  private_db_subnets        = module.vpc.private_db_subnets
  mongo_security_group_id   = module.vpc.mongo_sg
  public_bastion_subnet     = module.vpc.public_subnets[0]
  bastion_security_group_id = module.vpc.bastion_sg
}

module "rds" {
  source = "../../modules/rds"

  env                = var.env
  storage_size       = var.rds_storage_size
  instance_type      = var.rds_instance_type
  multi_az           = var.rds_multi_az
  username           = var.rds_username
  password           = var.rds_password
  create_replica     = var.create_replica
  create_snapshot    = var.create_snapshot
  security_group_id  = module.vpc.rds_sg
  private_db_subnets = module.vpc.private_db_subnets
}
