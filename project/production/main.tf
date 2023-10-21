locals {
  key_pair_name = "${var.env}-server-key-pair"
}

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

### ECR
module "ecr_app" {
  source = "../../modules/ecr"

  name = var.env
}

module "ecr_fluentbit" {
  source = "../../modules/ecr"

  name = "fluentbit-${var.env}"
}

### ECS
module "ecs" {
  source = "../../modules/ecs"

  # cluster
  cluster_name = "ecs-cluster-${var.env}"

  # task
  family                    = "ecs-template-app-${var.env}"
  task_cpu                  = 4096
  task_memory               = 8192
  app_container_name        = "app-container-${var.env}"
  app_repository_url        = module.ecr_app.repository_url
  app_cpu                   = 2048
  app_memory                = 4096
  app_container_port        = 8080
  app_container_health_port = 8081
  fluentbit_container_name  = "fluentbit-container-${var.env}"
  fluentbit_repository_url  = module.ecr_fluentbit.repository_url
  fluentbit_cpu             = 512
  fluentbit_memory          = 512
  fluentbit_port            = 8888
  fluentbit_environment = [
    {
      name  = "env"
      value = "${var.env}"
    }
  ]

  # service
  service_name         = "ecs-service-${var.env}"
  launch_type          = "FARGATE"
  desired_count        = var.desired_count
  subnets              = [for i in range(var.desired_count) : element(module.vpc.private_subnets, i)]
  security_group       = [module.vpc.app_sg]
  elb_target_group_arn = module.elb.target_group_arn
}

# ELB
module "elb" {
  source = "../../modules/elb"

  elb_name           = "elb-${var.env}"
  subnets            = module.vpc.public_subnets
  security_groups    = [module.vpc.default_sg]
  target_group_name  = "tg-${var.env}"
  target_port        = 8080
  vpc_id             = module.vpc.vpc_id
  health_check_port  = 8081
  ping_path          = "/actuator/health"
  certificate_domain = var.acm_domain
}

module "route53" {
  source = "../../modules/route53"

  create_private_zone = var.create_private_zone
  vpc_id              = module.vpc.vpc_id
  domain              = var.domain
  mongo_private_ip    = module.mongo-primary.private_ip
  rds_endpoint        = module.rds.rds_endpoint
  cache_endpoint      = module.elasticache_redis.primary_endpoint
  api_dns_name        = module.elb.dns_name
  api_zone_id         = module.elb.zone_id
}

module "kinesis" {
  source = "../../modules/kinesis"

  env                      = var.env
  log_shard_count          = var.log_shard_count
  notification_shard_count = var.notification_shard_count
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

### EC2
module "mongo-primary" {
  source = "../../modules/ec2"

  instance_type      = var.mongo_instance_type
  key_name           = local.key_pair_name
  subnet_id          = module.vpc.private_db_subnets[0]
  security_group_ids = [module.vpc.mongo_sg]
  volume_size        = 20
  ebs_tag_name       = "ebs_mongodb-primary-${var.env}"
  tag_name           = "mongodb-primary-${var.env}"
}

module "bastion" {
  source = "../../modules/ec2"

  instance_type      = var.bastion_instance_type
  key_name           = local.key_pair_name
  pulic_ip_enabled   = true
  subnet_id          = module.vpc.public_subnets[0]
  security_group_ids = [module.vpc.bastion_sg]
  volume_size        = 8
  ebs_tag_name       = "ebs_bastion-${var.env}"
  tag_name           = "bastion-${var.env}"
}

module "rds" {
  source = "../../modules/rds"

  env                     = var.env
  primary_instance_name   = "rds-primary-${var.env}"
  replica_instance_name   = "rds-replica-${var.env}"
  snapshot_name           = "rds-snapshot-${var.env}"
  db_subnet_group_name    = "rds-sg-${var.env}"
  db_parameter_group_name = "rds-pg-${var.env}"
  storage_size            = var.rds_storage_size
  instance_type           = var.rds_instance_type
  multi_az                = false
  username                = var.rds_username
  password                = var.rds_password
  create_replica          = false
  create_snapshot         = false
  security_group_id       = module.vpc.rds_sg
  private_db_subnets      = module.vpc.private_db_subnets
}

module "notification_lambda" {
  source = "../../modules/lambda"

  role_name              = var.notification_lambda_role_name
  dir                    = true
  dir_path               = var.notification_function_dir_path
  zip_path               = var.notification_function_zip_path
  function_name          = "notification-lambda-${var.env}"
  handler_name           = var.notification_handler
  environment            = var.notification_environment
  layer_names            = [var.fcm_layer_name]
  create_kinesis_trigger = true
  kinesis_arn            = module.kinesis.notification_arn
}

module "notification_lambda_log_goup" {
  source = "../../modules/cloudwatch"

  log_group_name = "/aws/lambda/${module.notification_lambda.function_name}"
  retention_days = 3
}

# ElastiCache
module "elasticache_redis" {
  source = "../../modules/elasticache"

  preffered_cluster_azs = [for i in range(var.num_cache_clusters) : element(var.availability_zones, i)]
  group_id              = "redis-group-${var.env}"
  node_type             = var.node_type
  num_cache_clusters    = var.num_cache_clusters
  security_group_ids    = [module.vpc.cache_sg]
  subnet_group_name     = "redis-subnet-group-${var.env}"
  subnet_ids            = module.vpc.private_db_subnets
  user_id               = var.user_id
  user_name             = var.user_name
  passwords             = var.passwords
}
