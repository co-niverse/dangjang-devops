output "primary_endpoint" {
  description = "endpoint address of primary node"
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "replica_endpoint" {
  description = "endpoint address of replica node"
  value       = aws_elasticache_replication_group.redis.reader_endpoint_address
}
