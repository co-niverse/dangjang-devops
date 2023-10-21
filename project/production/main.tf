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

### ELB
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
  rds_endpoint        = module.rds.primary_endpoint
  cache_endpoint      = module.elasticache_redis.primary_endpoint
  api_dns_name        = module.elb.dns_name
  api_zone_id         = module.elb.zone_id
}

### Kinesis
module "kinesis_client_log" {
  source = "../../modules/kinesis"

  name        = "kn-client-log-${var.env}"
  shard_count = 1
}

module "kinesis_server_log" {
  source = "../../modules/kinesis"

  name        = "kn-server-log-${var.env}"
  shard_count = 1
}

module "kinesis_notification" {
  source = "../../modules/kinesis"

  name        = "kn-notification-${var.env}"
  shard_count = 1
}

### Firehose
module "firehose_client_log_s3" {
  source = "../../modules/firehose"

  name               = "fh-client-log-s3-stream-${var.env}"
  destination        = "extended_s3"
  kinesis_stream_arn = module.kinesis_client_log.arn
  configuration = {
    extended_s3 = {
      bucket_arn         = module.s3.client_log_arn
      buffering_interval = 300
    }
  }
}

module "firehose_client_log_opensearch" {
  source = "../../modules/firehose"

  name               = "fh-client-log-opensearch-stream-${var.env}"
  destination        = "opensearch"
  kinesis_stream_arn = module.kinesis_client_log.arn
  configuration = {
    opensearch = {
      bucket_arn         = module.s3.client_log_arn
      buffering_interval = 300
      domain_arn         = module.log_opensearch.arn
      index_name         = "client-log"
      s3_backup_mode     = "FailedDocumentsOnly"
    }
  }
}

module "firehose_server_log_s3" {
  source = "../../modules/firehose"

  name               = "fh-server-log-s3-stream-${var.env}"
  destination        = "extended_s3"
  kinesis_stream_arn = module.kinesis_server_log.arn
  configuration = {
    extended_s3 = {
      bucket_arn         = module.s3.server_log_arn
      buffering_interval = 300
    }
  }
}

module "firehose_server_log_opensearch" {
  source = "../../modules/firehose"

  name               = "fh-server-log-opensearch-stream-${var.env}"
  destination        = "opensearch"
  kinesis_stream_arn = module.kinesis_server_log.arn
  configuration = {
    opensearch = {
      bucket_arn         = module.s3.server_log_arn
      buffering_interval = 300
      domain_arn         = module.log_opensearch.arn
      index_name         = "server-log"
      s3_backup_mode     = "FailedDocumentsOnly"
    }
  }
}

### OpenSearch
module "log_opensearch" {
  source = "../../modules/opensearch"

  name                 = "os-log-${var.env}"
  instance_type        = var.instance_type
  instance_count       = 1
  ebs_enabled          = true
  volume_size          = 20
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

### RDS
module "rds" {
  source = "../../modules/rds"

  primary_instance_name = "rds-primary-${var.env}"
  storage_size          = 50
  instance_class        = var.rds_instance_type
  multi_az              = false
  username              = var.rds_username
  password              = var.rds_password
  db_name               = var.env
  security_group_ids    = [module.vpc.rds_sg]
  create_replica        = false
  replica_instance_name = "rds-replica-${var.env}"
  create_snapshot       = false
  snapshot_name         = "rds-snapshot-${var.env}"
  subnet_group_name     = "rds-sg-${var.env}"
  subnet_ids            = module.vpc.private_db_subnets
  parameter_group_name  = "rds-pg-${var.env}"
}

### Lambda
module "notification_lambda" {
  source = "../../modules/lambda"

  role_name              = "notification-lambda-role"
  layer_names            = ["fcm_layer"]
  dir                    = true
  dir_path               = "../../function/notification/"
  zip_path               = "../../function/notification.zip"
  function_name          = "notification-lambda-${var.env}"
  handler_name           = "notification.lambda_handler"
  environment            = var.notification_environment
  create_kinesis_trigger = true
  kinesis_arn            = module.kinesis_notification.arn
}

### Log group
module "notification_lambda_log_goup" {
  source = "../../modules/cloudwatch"

  log_group_name = "/aws/lambda/${module.notification_lambda.function_name}"
  retention_days = 3
}

### ElastiCache
module "elasticache_redis" {
  source = "../../modules/elasticache"

  group_id              = "redis-group-${var.env}"
  preffered_cluster_azs = [for i in range(var.num_cache_clusters) : element(var.availability_zones, i)]
  node_type             = var.node_type
  num_cache_clusters    = var.num_cache_clusters
  security_group_ids    = [module.vpc.cache_sg]
  subnet_group_name     = "redis-subnet-group-${var.env}"
  subnet_ids            = module.vpc.private_db_subnets
  user_id               = var.user_id
  user_name             = var.user_name
  passwords             = var.passwords
}
