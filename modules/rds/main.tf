###################
#       RDS       #
###################

# RDS instance - Primary
resource "aws_db_instance" "primary" {
  identifier        = var.primary_instance_name
  allocated_storage = var.storage_size
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  storage_type      = var.stoarge_type
  multi_az          = var.multi_az

  username = var.username
  password = var.password
  db_name  = var.db_name

  parameter_group_name       = aws_db_parameter_group.rds.name
  db_subnet_group_name       = aws_db_subnet_group.rds.name
  skip_final_snapshot        = var.skip_final_snapshot
  vpc_security_group_ids     = var.security_group_ids
  apply_immediately          = var.apply_immediately
  backup_retention_period    = var.backup_retention_period
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
}

# RDS instance - Read Replica
resource "aws_db_instance" "replica" {
  count               = var.create_replica ? 1 : 0
  replicate_source_db = aws_db_instance.primary.id

  identifier        = var.replica_instance_name
  allocated_storage = var.storage_size
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  storage_type      = var.stoarge_type
  multi_az          = var.multi_az

  username = var.username
  password = var.password
  db_name  = var.db_name

  parameter_group_name       = aws_db_parameter_group.rds.name
  db_subnet_group_name       = aws_db_subnet_group.rds.name
  skip_final_snapshot        = var.skip_final_snapshot
  vpc_security_group_ids     = var.security_group_ids
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
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
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.subnet_group_name
  }
}

# Parameter Group
resource "aws_db_parameter_group" "rds" {
  name        = var.parameter_group_name
  family      = var.parameter_family
  description = "RDS Parameter Group"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  lifecycle {
    ignore_changes = [
      description
    ]
  }
}
