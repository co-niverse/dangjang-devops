###################
#       RDS       #
###################

# RDS instance - Primary
resource "aws_db_instance" "primary" {
  identifier        = var.primary_instance_name
  allocated_storage = var.storage_size
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_type
  storage_type      = var.stoarge_type
  multi_az          = var.multi_az

  username = var.username
  password = var.password
  db_name  = var.env

  parameter_group_name    = aws_db_parameter_group.rds.name
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  skip_final_snapshot     = var.skip_final_snapshot
  vpc_security_group_ids  = [var.security_group_id]
  apply_immediately       = var.apply_immediately
  backup_retention_period = var.backup_retention_period
}

# RDS instance - Read Replica
resource "aws_db_instance" "replica" {
  count               = var.create_replica ? 1 : 0
  replicate_source_db = aws_db_instance.primary.id

  identifier        = var.replica_instance_name
  allocated_storage = var.storage_size
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_type
  storage_type      = var.stoarge_type
  multi_az          = var.multi_az

  username = var.username
  password = var.password
  db_name  = var.env

  parameter_group_name   = aws_db_parameter_group.rds.name
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = ["${var.security_group_id}"]
  apply_immediately      = var.apply_immediately
}

# ---------------------------------------------------------
# RDS Snapshot
resource "aws_db_snapshot" "rds" {
  count                  = var.create_snapshot ? 1 : 0
  db_instance_identifier = aws_db_instance.primary.id
  db_snapshot_identifier = var.snapshot_name
}

# Subnet Group
resource "aws_db_subnet_group" "rds" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_db_subnets

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = var.db_subnet_group_name
  }
}

# Parameter Group
resource "aws_db_parameter_group" "rds" {
  name        = var.db_parameter_group_name
  family      = var.db_parameter_family
  description = "RDS Parameter Group-${var.env}"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8_general_ci"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8_general_ci"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "lower_case_table_names"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "time_zone"
    value = "Asia/Seoul"
  }
}
