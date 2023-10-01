###################
#       RDS       #
###################

# RDS instance - Primary
resource "aws_db_instance" "primary" {
  identifier        = "rds-${var.env}"
  allocated_storage = var.storage_size
  engine            = "mysql"
  engine_version    = "8.0.33"
  instance_class    = var.instance_type
  storage_type      = "gp3"
  multi_az          = var.multi_az

  username = var.username
  password = var.password
  db_name  = var.env

  parameter_group_name   = aws_db_parameter_group.rds.name
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${var.security_group_id}"]
  apply_immediately      = true
  backup_retention_period = 7
}

# RDS instance - Read Replica
resource "aws_db_instance" "replica" {
  count               = var.create_replica ? 1 : 0
  replicate_source_db = aws_db_instance.primary.id

  identifier        = "rds-${var.env}-replica"
  allocated_storage = var.storage_size
  engine            = "mysql"
  engine_version    = "8.0.33"
  instance_class    = var.instance_type
  storage_type      = "gp3"
  multi_az          = var.multi_az

  username = var.username
  password = var.password
  db_name  = var.env

  parameter_group_name   = aws_db_parameter_group.rds.name
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${var.security_group_id}"]
  apply_immediately      = true
}

# ---------------------------------------------------------
# RDS Snapshot
resource "aws_db_snapshot" "rds" {
  count                  = var.create_snapshot ? 1 : 0
  db_instance_identifier = aws_db_instance.primary.id
  db_snapshot_identifier = "rds-${var.env}-snapshot"
}

# Subnet Group
resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group-${var.env}"
  subnet_ids = var.private_db_subnets

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "rds-subnet-group-${var.env}"
  }
}

# Parameter Group
resource "aws_db_parameter_group" "rds" {
  name        = "rds-pg-${var.env}"
  family      = "mysql8.0"
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
    name  = "collation_connection"
    value = "utf8_general_ci"
  }

  parameter {
    name  = "collation_server"
    value = "utf8_general_ci"
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
