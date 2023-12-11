###################
#   ElastiCache   #
###################

### replication group
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id        = var.group_id
  description                 = "Redis replication group"
  multi_az_enabled            = var.multi_az_enabled
  automatic_failover_enabled  = var.failover_enabled
  preferred_cache_cluster_azs = var.preffered_cluster_azs
  node_type                   = var.node_type
  num_cache_clusters          = var.num_cache_clusters
  engine                      = var.engine
  engine_version              = var.engine_version
  parameter_group_name        = var.parameter_group_name
  port                        = var.port
  subnet_group_name           = aws_elasticache_subnet_group.redis.name
  security_group_ids          = var.security_group_ids
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  # user_group_ids              = [aws_elasticache_user_group.redis[0].id]
}

### subnet group
resource "aws_elasticache_subnet_group" "redis" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}

### user
resource "aws_elasticache_user" "redis" {
  count         = var.create_user ? 1 : 0
  user_id       = var.user_id
  user_name     = var.user_name
  access_string = var.access_string
  engine        = upper(var.engine)

  authentication_mode { # 인증 모드
    type      = "password"
    passwords = var.passwords
  }

  lifecycle {
    create_before_destroy = true
  }
}

### user group
resource "aws_elasticache_user_group" "redis" {
  count         = var.create_user ? 1 : 0
  user_group_id = "${var.user_id}-group"
  engine        = upper(var.engine)
  user_ids      = [aws_elasticache_user.redis[0].id, "default"]
}
