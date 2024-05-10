terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE DATABASE
# ---------------------------------------------------------------------------------------------------------------------

module "aurora_postgresql" {
  source = "git@github.com:gruntwork-io/terraform-aws-service-catalog.git//modules/data-stores/aurora?ref=v0.111.2"

  name            = var.name
  db_name         = var.db_name
  master_username = var.master_username
  master_password = var.master_password

  # Configure Aurora for PostgreSQL compatibility
  engine         = "aurora-postgresql"
  engine_version = var.engine_version
  port           = 5432

  # Configure Aurora for serverless v2 mode. Even though engine_mode supports a "serverless" value, for serverless v2,
  # you actually have to use "provisioned" mode. You also have to provide a scaling configuration, enable encryption,
  # set the instance_count to 1, and the instance_type to db.serverless.
  engine_mode                           = "provisioned"
  storage_encrypted                     = true
  kms_key_arn                           = var.kms_key_arn
  instance_count                        = 1
  instance_type                         = "db.serverless"
  scaling_configuration_max_capacity_V2 = var.scaling_configuration_max_capacity_V2
  scaling_configuration_min_capacity_V2 = var.scaling_configuration_min_capacity_V2

  vpc_id            = var.vpc_id
  aurora_subnet_ids = var.subnet_ids

  db_cluster_custom_parameter_group  = var.db_cluster_custom_parameter_group
  db_instance_custom_parameter_group = var.db_instance_custom_parameter_group

  allow_connections_from_cidr_blocks     = var.allow_connections_from_cidr_blocks
  allow_connections_from_security_groups = var.allow_connections_from_security_groups

  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  enable_deletion_protection   = var.enable_deletion_protection
  skip_final_snapshot          = var.skip_final_snapshot
  preferred_maintenance_window = var.preferred_maintenance_window
  preferred_backup_window      = var.preferred_backup_window
  backup_retention_period      = var.backup_retention_period

  snapshot_identifier               = var.snapshot_identifier
  restore_source_cluster_identifier = var.restore_source_cluster_identifier
  restore_type                      = var.restore_type
}
