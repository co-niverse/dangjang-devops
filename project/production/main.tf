locals {
  all_cidr_block = "0.0.0.0/0"
  tcp            = "tcp"
  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [local.all_cidr_block]
    }
  ]
  default_cas_name = "cas-default"
  spot_cas_name    = "cas-spot"
}

### VPC
module "vpc" {
  source = "../../modules/vpc/vpc"

  vpc_name     = "vpc-${var.env}"
  igw_name     = "igw-${var.env}"
  cidr_numeral = var.cidr_numeral
}

module "public_subnets" {
  source = "../../modules/vpc/subnet"

  vpc_id           = module.vpc.vpc_id
  vpc_cidr_numeral = var.cidr_numeral
  subnets = {
    for i in range(length(var.availability_zones)) : "public-sb${i}-${var.env}" => {
      numeral           = var.cidr_numeral_public[i]
      availability_zone = element(var.availability_zones, i)
    }
  }
  map_public_ip_on_launch = true
  route_table_name        = "public-rt-${var.env}"
  enable_igw_destination  = true
  igw_id                  = module.vpc.igw_id
}

module "private_app_subnets" {
  source = "../../modules/vpc/subnet"

  vpc_id           = module.vpc.vpc_id
  vpc_cidr_numeral = var.cidr_numeral
  subnets = {
    for i in range(length(var.availability_zones)) : "private-app-sb${i}-${var.env}" => {
      numeral           = var.cidr_numeral_private[i]
      availability_zone = element(var.availability_zones, i)
    }
  }
  route_table_name                     = "private-app-rt-${var.env}"
  enable_network_interface_destination = true
  network_interface_id                 = module.bastion.network_interface_id
}

module "private_db_subnets" {
  source = "../../modules/vpc/subnet"

  vpc_id           = module.vpc.vpc_id
  vpc_cidr_numeral = var.cidr_numeral
  subnets = {
    for i in range(length(var.availability_zones)) : "private-db-sb${i}-${var.env}" => {
      numeral           = var.cidr_numeral_private_db[i]
      availability_zone = element(var.availability_zones, i)
    }
  }
  route_table_name                     = "private-db-rt-${var.env}"
  enable_network_interface_destination = true
  network_interface_id                 = module.bastion.network_interface_id
}

module "nat_gateway" {
  source = "../../modules/vpc/nat_gateway"

  create_nat       = false
  elastic_ip_name  = "nat-gw-eip-${var.env}"
  subnet_id        = module.public_subnets.ids[0]
  nat_gateway_name = "nat-gw-${var.env}"
}

module "security_group_elb" {
  source = "../../modules/vpc/security_group"

  name   = "elb-sg-${var.env}"
  vpc_id = module.vpc.vpc_id
  ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = local.tcp
      cidr_blocks = [local.all_cidr_block]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp
      cidr_blocks = [local.all_cidr_block]
    }
  ]
  egress = local.egress
}

module "security_group_app" {
  source = "../../modules/vpc/security_group"

  name   = "app-sg-${var.env}"
  vpc_id = module.vpc.vpc_id
  ingress = [
    {
      from_port       = var.app_container_port
      to_port         = var.app_container_port
      protocol        = local.tcp
      security_groups = [module.security_group_elb.id]
    },
    {
      from_port       = var.app_container_health_check_port
      to_port         = var.app_container_health_check_port
      protocol        = local.tcp
      security_groups = [module.security_group_elb.id]
    }
  ]
  egress = local.egress
}

module "security_group_fluentbit" {
  source = "../../modules/vpc/security_group"

  name   = "fluentbit-sg-${var.env}"
  vpc_id = module.vpc.vpc_id
  ingress = [
    {
      from_port       = 8888
      to_port         = 8888
      protocol        = local.tcp
      security_groups = [module.security_group_app.id]
    }
  ]
  egress = local.egress
}

module "security_group_rds" {
  source = "../../modules/vpc/security_group"

  name   = "rds-sg-${var.env}"
  vpc_id = module.vpc.vpc_id
  ingress = [
    {
      from_port       = 3306
      to_port         = 3306
      protocol        = local.tcp
      security_groups = [module.security_group_app.id, module.security_group_bastion.id]
    }
  ]
  egress = local.egress
}

module "security_group_mongo" {
  source = "../../modules/vpc/security_group"

  name   = "mongo-sg-${var.env}"
  vpc_id = module.vpc.vpc_id
  ingress = [
    {
      from_port       = 27017
      to_port         = 27017
      protocol        = local.tcp
      security_groups = [module.security_group_app.id]
    }
  ]
  egress = local.egress
}

module "security_group_cache" {
  source = "../../modules/vpc/security_group"

  name   = "cache-sg-${var.env}"
  vpc_id = module.vpc.vpc_id
  ingress = [
    {
      from_port       = 6379
      to_port         = 6379
      protocol        = local.tcp
      security_groups = [module.security_group_app.id, module.security_group_bastion.id]
    }
  ]
  egress = local.egress
}

module "security_group_bastion" {
  source = "../../modules/vpc/security_group"

  name   = "bastion-sg-${var.env}"
  vpc_id = module.vpc.vpc_id
  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = local.tcp
      cidr_blocks = [local.all_cidr_block]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = local.tcp
      cidr_blocks = ["10.${var.cidr_numeral}.0.0/16"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp
      cidr_blocks = ["10.${var.cidr_numeral}.0.0/16"]
    }
  ]
  egress = local.egress
}

module "security_group_ssh_bastion" {
  source = "../../modules/vpc/security_group"

  name   = "ssh-sg-${var.env}"
  vpc_id = module.vpc.vpc_id
  ingress = [
    {
      from_port       = 22
      to_port         = 22
      protocol        = local.tcp
      security_groups = [module.security_group_bastion.id]
    }
  ]
  egress = local.egress
}

module "vpc_endpoint_s3" {
  source = "../../modules/vpc/endpoint"

  create_gateway  = true
  vpc_id          = module.vpc.vpc_id
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [module.private_app_subnets.route_table_id]
  endpoint_name   = "s3-endpoint-${var.env}"
}

module "vpc_endpoint_kinesis" {
  source = "../../modules/vpc/endpoint"

  create_interface = false
  vpc_id           = module.vpc.vpc_id
  service_name     = "com.amazonaws.${var.aws_region}.kinesis-streams"
  subnet_ids       = module.private_app_subnets.ids
  endpoint_name    = "kinesis-endpoint-${var.env}"
}

### Route53
module "public_zone" {
  source = "../../modules/route53/zone"

  domain = var.domain
}

module "elb_record" {
  source = "../../modules/route53/record"

  zone_id = module.public_zone.zone_id
  name    = "api.${var.domain}"
  type    = "A"
  alias = {
    name                   = module.elb.dns_name
    zone_id                = module.elb.zone_id
    evaluate_target_health = true
  }
}

module "private_zone" {
  source = "../../modules/route53/zone"

  domain = var.domain
  vpc_id = module.vpc.vpc_id
}

module "mongo_record" {
  source = "../../modules/route53/record"

  zone_id = module.private_zone.zone_id
  name    = "mongo.${var.domain}"
  type    = "A"
  records = [module.mongo_primary.private_ip]
}

module "rds_record" {
  source = "../../modules/route53/record"

  zone_id = module.private_zone.zone_id
  name    = "rds.${var.domain}"
  type    = "CNAME"
  records = [module.rds.primary_endpoint]
}

module "cache_record" {
  source = "../../modules/route53/record"

  zone_id = module.private_zone.zone_id
  name    = "cache.${var.domain}"
  type    = "CNAME"
  records = [module.elasticache_redis.primary_endpoint]
}

### ACM
module "acm" {
  source = "../../modules/acm"

  domain_name               = var.domain
  subject_alternative_names = ["*.${var.domain}"]
}

### ELB
module "elb" {
  source = "../../modules/elb"

  elb_name             = "elb-${var.env}"
  subnets              = module.public_subnets.ids
  security_groups      = [module.security_group_elb.id]
  target_group_name    = "tg-${var.env}"
  target_type          = "ip"
  target_port          = var.app_container_port
  vpc_id               = module.vpc.vpc_id
  deregistration_delay = 60
  health_check_port    = var.app_container_health_check_port
  ping_path            = "/actuator/health"
  certificate_domain   = module.acm.certificate_arn
}

### EC2
module "mongo_primary" {
  source = "../../modules/ec2/instance"

  instance_type         = var.mongo_instance_type
  key_name              = module.key_pair.name
  subnet_id             = module.private_db_subnets.ids[0]
  security_group_ids    = [module.security_group_mongo.id, module.security_group_ssh_bastion.id]
  delete_on_termination = false
  volume_size           = 20
  ebs_name              = "ebs-mongo-primary-${var.env}"
  instance_name         = "mongo-primary-${var.env}"
}

module "bastion" {
  source = "../../modules/ec2/instance"

  ami                = "ami-0c2d3e23e757b5d84" # NAT Instance
  instance_type      = var.bastion_instance_type
  key_name           = module.key_pair.name
  pulic_ip_enabled   = true
  subnet_id          = module.public_subnets.ids[0]
  security_group_ids = [module.security_group_bastion.id]
  source_dest_check  = false
  volume_type        = "standard"
  ebs_name           = "ebs-bastion-${var.env}"
  instance_name      = "bastion-${var.env}"
}

module "key_pair" {
  source = "../../modules/ec2/key-pair"

  key_name        = "${var.env}-server-key-pair"
  public_key_path = "../../public-key-pair/${var.env}.txt"
}

### Launch Template
module "launch_template" {
  source = "../../modules/ec2/launch-template"

  ecs_cluster_name = module.ecs_cluster.name
  ec2_role_name    = "ecs-ec2-role"
  profile_name     = "ecs-app-instance-profile-${var.env}"
  template_name    = "ecs-app-instance-launch-template-${var.env}"
  image_id         = "ami-0c1ffd9e3d9b0f4af" # ecs optimized AMI arm64
  instance_type    = var.launch_template_instance_type
  key_name         = module.key_pair.name
  vpc_security_group_ids = [module.security_group_ssh_bastion.id]
  ebs_tag_name     = "ebs-ecs-instance-${var.env}"
}

### Auto Scaling Group
module "asg_default" {
  source = "../../modules/ec2/auto-scaling-group"

  name                = "asg-default-${var.env}"
  desired_capacity    = 0
  max_size            = 10
  min_size            = 0
  vpc_zone_identifier = module.private_app_subnets.ids
  launch_template_id  = module.launch_template.id
  instance_name       = "${module.ecs_cluster.name}-instance"
  ecs_managed         = true
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
  security_group_ids    = [module.security_group_rds.id]
  create_replica        = false
  replica_instance_name = "rds-replica-${var.env}"
  create_snapshot       = false
  snapshot_name         = "rds-snapshot-${var.env}"
  subnet_group_name     = "rds-sg-${var.env}"
  subnet_ids            = module.private_db_subnets.ids
  parameter_group_name  = "rds-pg-${var.env}"
}

### ElastiCache
module "elasticache_redis" {
  source = "../../modules/elasticache"

  group_id              = "redis-group-${var.env}"
  preffered_cluster_azs = [for i in range(var.num_cache_clusters) : element(var.availability_zones, i)]
  node_type             = var.node_type
  num_cache_clusters    = var.num_cache_clusters
  security_group_ids    = [module.security_group_cache.id]
  subnet_group_name     = "redis-subnet-group-${var.env}"
  subnet_ids            = module.private_db_subnets.ids
  user_id               = var.user_id
  user_name             = var.user_name
  passwords             = var.passwords
}

### S3
module "s3_client_log" {
  source = "../../modules/s3"

  bucket_name = "${var.env}.client-log.dangjang"
}

module "s3_server_log" {
  source = "../../modules/s3"

  bucket_name = "${var.env}.server-log.dangjang"
}

# module "s3_user_image" {
#   source = "../../modules/s3"

#   bucket_name = "dangjang.user.image-${var.env}"
# }

### ECR
module "ecr_app" {
  source = "../../modules/ecr"

  name        = "app-${var.env}"
  identifiers = var.users
}

module "ecr_fluentbit" {
  source = "../../modules/ecr"

  name        = "fluentbit-${var.env}"
  identifiers = var.users
}

### ECS
module "ecs_cluster" {
  source = "../../modules/ecs/cluster"

  cluster_name  = "ecs-cluster-${var.env}"
  namespace_arn = module.cluster_namespace.arn
  cas = { (local.default_cas_name) = {
    auto_scaling_group_arn         = module.asg_default.arn
    managed_termination_protection = "DISABLED"
    status                         = "ENABLED"
    }
  }
}

module "cluster_namespace" {
  source = "../../modules/cloudmap"

  name = "dangjang-ecs-cluster-${var.env}"
}

module "task_definition_app" {
  source = "../../modules/ecs/task-definition"

  family                   = "ecs-template-app-${var.env}"
  task_cpu                 = 1536
  task_memory              = 1536
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  container_name           = var.app_container_name
  repository_url           = module.ecr_app.repository_url
  container_cpu            = 1024
  container_memory         = 1024
  port_mappings = [
    {
      hostPort      = var.app_container_port
      containerPort = var.app_container_port
    },
    {
      hostPort      = var.app_container_health_check_port
      containerPort = var.app_container_health_check_port
    }
  ]
}

module "ecs_service_app_default" {
  source = "../../modules/ecs/service"

  service_name                      = "ecs-service-app-default-${var.env}"
  cluster_name                      = module.ecs_cluster.name
  task_definition_arn               = module.task_definition_app.arn
  desired_count                     = var.desired_count
  health_check_grace_period_seconds = 180

  network_configuration = {
    subnets         = module.private_app_subnets.ids
    security_groups = [module.security_group_app.id]
  }
  load_balancer = {
    target_group_arn = module.elb.target_group_arn
    container_name   = var.app_container_name
    container_port   = var.app_container_port
  }
  capacity_provider_strategy = [
    {
      capacity_provider = local.default_cas_name
      base              = 0
      weight            = 1
    },
  ]
  ordered_placement_strategy = [
    {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    },
    {
      type  = "binpack"
      field = "memory"
    }
  ]
  service_connect_configuration = {
    namespace = module.cluster_namespace.arn
  }
}

module "task_definition_fluentbit" {
  source = "../../modules/ecs/task-definition"

  family                   = "ecs-template-fluentbit-${var.env}"
  requires_compatibilities = ["EC2"]
  task_cpu                 = 512
  task_memory              = 256
  network_mode             = "awsvpc"
  container_name           = var.fluentbit_container_name
  repository_url           = module.ecr_fluentbit.repository_url
  container_cpu            = 256
  container_memory         = 128
  port_mappings = [
    {
      hostPort      = var.fluentbit_container_port
      containerPort = var.fluentbit_container_port
      name          = "fluentbit"
      appProtocol   = "http"
    }
  ]
  environment = [
    {
      name  = "env"
      value = var.env
    }
  ]
}

module "ecs_service_fluentbit" {
  source = "../../modules/ecs/service"

  service_name        = "ecs-service-fluentbit-${var.env}"
  cluster_name        = module.ecs_cluster.name
  task_definition_arn = module.task_definition_fluentbit.arn
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"
  network_configuration = {
    subnets         = module.private_app_subnets.ids
    security_groups = [module.security_group_fluentbit.id]
  }
  service_connect_configuration = {
    namespace = module.cluster_namespace.arn
    service = {
      port_name = "fluentbit"
      client_alias = {
        port = var.fluentbit_container_port
      }
    }
  }
}

# ### Kinesis
# module "kinesis_client_log" {
#   source = "../../modules/kinesis"

#   name        = "kn-client-log-${var.env}"
#   shard_count = 1
# }

# module "kinesis_server_log" {
#   source = "../../modules/kinesis"

#   name        = "kn-server-log-${var.env}"
#   shard_count = 1
# }

# module "kinesis_notification" {
#   source = "../../modules/kinesis"

#   name        = "kn-notification-${var.env}"
#   shard_count = 1
# }

# ### Firehose
# module "firehose_client_log_s3" {
#   source = "../../modules/firehose"

#   name               = "fh-client-log-s3-stream-${var.env}"
#   destination        = "extended_s3"
#   kinesis_stream_arn = module.kinesis_client_log.arn
#   configuration = {
#     extended_s3 = {
#       bucket_arn         = module.s3_client_log.arn
#       buffering_interval = 300
#     }
#   }
# }

# module "firehose_client_log_opensearch" {
#   source = "../../modules/firehose"

#   name               = "fh-client-log-opensearch-stream-${var.env}"
#   destination        = "opensearch"
#   kinesis_stream_arn = module.kinesis_client_log.arn
#   configuration = {
#     opensearch = {
#       bucket_arn         = module.s3_client_log.arn
#       buffering_interval = 300
#       domain_arn         = module.log_opensearch.arn
#       index_name         = "client-log"
#       s3_backup_mode     = "FailedDocumentsOnly"
#     }
#   }
# }

# module "firehose_server_log_s3" {
#   source = "../../modules/firehose"

#   name               = "fh-server-log-s3-stream-${var.env}"
#   destination        = "extended_s3"
#   kinesis_stream_arn = module.kinesis_server_log.arn
#   configuration = {
#     extended_s3 = {
#       bucket_arn         = module.s3_server_log.arn
#       buffering_interval = 300
#     }
#   }
# }

# module "firehose_server_log_opensearch" {
#   source = "../../modules/firehose"

#   name               = "fh-server-log-opensearch-stream-${var.env}"
#   destination        = "opensearch"
#   kinesis_stream_arn = module.kinesis_server_log.arn
#   configuration = {
#     opensearch = {
#       bucket_arn         = module.s3_server_log.arn
#       buffering_interval = 300
#       domain_arn         = module.log_opensearch.arn
#       index_name         = "server-log"
#       s3_backup_mode     = "FailedDocumentsOnly"
#     }
#   }
# }

# ### OpenSearch
# module "log_opensearch" {
#   source = "../../modules/opensearch"

#   name                 = "os-log-${var.env}"
#   instance_type        = var.instance_type
#   instance_count       = 1
#   ebs_enabled          = true
#   volume_size          = 20
#   master_user_name     = var.master_user_name
#   master_user_password = var.master_user_password
# }

# ### Lambda
# module "notification_lambda" {
#   source = "../../modules/lambda"

#   role_name              = "notification-lambda-role"
#   layer_names            = ["fcm_layer"]
#   dir                    = true
#   dir_path               = "../../function/notification/"
#   zip_path               = "../../function/notification.zip"
#   function_name          = "notification-lambda-${var.env}"
#   handler_name           = "notification.lambda_handler"
#   environment            = var.notification_environment
#   create_kinesis_trigger = true
#   kinesis_arn            = module.kinesis_notification.arn
# }

# ### Log group
# module "notification_lambda_log_goup" {
#   source = "../../modules/cloudwatch"

#   log_group_name = "/aws/lambda/${module.notification_lambda.function_name}"
#   retention_days = 3
# }