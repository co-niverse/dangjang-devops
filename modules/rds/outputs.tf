###################
#       RDS       #
###################

output "rds_endpoint" {
  description = "endpoint of rds"
  value = aws_db_instance.primary.address
}