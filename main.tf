##################################################
#   VPC
##################################################
module "vpc" {
  source = "shamimice03/vpc/aws"

  vpc_name = var.vpc_name
  cidr     = var.cidr

  azs                 = var.azs
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  db_subnet_cidr      = var.db_subnet_cidr

  enable_dns_hostnames      = var.enable_dns_hostnames
  enable_dns_support        = var.enable_dns_support
  enable_single_nat_gateway = var.enable_single_nat_gateway

  tags = merge(
    { "Name" = var.vpc_name },
    var.general_tags,
  )
}

##################################################
#    Primary Database
##################################################
locals {
  rds_security_group = [aws_security_group.rds_sg.id]
}


module "rds" {
  source = "shamimice03/rds-blueprint/aws"

  create_db_subnet_group = var.create_db_subnet_group
  db_subnet_group_name   = var.db_subnet_group_name
  db_subnets             = coalesce(module.vpc.db_subnet_id, var.db_subnets)

  # Identify DB instance
  db_identifier = var.db_identifier

  # Create Initial Database
  db_name = var.db_name

  # Credentials Settings
  # password will be auto generated
  db_master_username                  = var.db_master_username
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  # Availability and durability
  multi_az          = var.multi_az
  availability_zone = var.master_db_availability_zone

  # Engine options
  engine         = var.engine
  engine_version = var.engine_version

  # DB Instance configurations
  instance_class = var.instance_class

  # Storage
  storage_type          = var.storage_type
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  # Connectivity
  db_security_groups  = coalesce(local.rds_security_group, var.db_security_groups)
  publicly_accessible = var.publicly_accessible
  database_port       = var.database_port

  # Backup and Maintenance
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  deletion_protection     = var.deletion_protection


  # Monitoring
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # Others
  apply_immediately        = var.apply_immediately
  delete_automated_backups = var.delete_automated_backups
  skip_final_snapshot      = var.skip_final_snapshot

  tags = merge(
    { "Name" = var.db_identifier },
    var.general_tags,
  )
}

##################################################
#    Read Replica
##################################################
module "rds_replica" {
  source = "shamimice03/rds-blueprint/aws"

  replicate_source_db                 = var.db_identifier
  db_identifier                       = coalesce(var.replica_db_identifier, "${var.db_identifier}-replica")
  multi_az                            = coalesce(var.replica_multi_az, var.multi_az)
  availability_zone                   = coalesce(var.replica_db_availability_zone, var.master_db_availability_zone)
  engine                              = coalesce(var.replica_engine, var.engine)
  engine_version                      = coalesce(var.replica_engine_version, var.engine_version)
  instance_class                      = coalesce(var.replica_instance_class, var.instance_class)
  iam_database_authentication_enabled = coalesce(var.replica_iam_database_authentication_enabled, var.iam_database_authentication_enabled)
  storage_type                        = coalesce(var.replica_storage_type, var.storage_type)
  # allocated_storage                   = coalesce(var.replica_allocated_storage, var.allocated_storage)
  max_allocated_storage           = coalesce(var.replica_max_allocated_storage, var.max_allocated_storage)
  db_security_groups              = coalesce(local.rds_security_group, var.db_security_groups)
  publicly_accessible             = coalesce(var.replica_publicly_accessible, var.publicly_accessible)
  database_port                   = coalesce(var.replica_database_port, var.database_port)
  backup_retention_period         = coalesce(var.replica_backup_retention_period, var.backup_retention_period)
  backup_window                   = coalesce(var.replica_backup_window, var.backup_window)
  maintenance_window              = coalesce(var.replica_maintenance_window, var.maintenance_window)
  deletion_protection             = coalesce(var.replica_deletion_protection, var.deletion_protection)
  enabled_cloudwatch_logs_exports = coalesce(var.replica_enabled_cloudwatch_logs_exports, var.enabled_cloudwatch_logs_exports)
  apply_immediately               = coalesce(var.replica_apply_immediately, var.apply_immediately)
  delete_automated_backups        = coalesce(var.replica_delete_automated_backups, var.delete_automated_backups)
  skip_final_snapshot             = coalesce(var.replica_skip_final_snapshot, var.skip_final_snapshot)

  tags = merge(
    { "Name" = "${var.db_identifier}-replica" },
    var.general_tags,
  )

  depends_on = [module.rds]
}

##################################################
# Store Database Parameters to SSM Parameter Store
##################################################

locals {
  replica_db_identifier        = coalesce(var.replica_db_identifier, "${var.db_identifier}-replica")
  primary_db_parameters_prefix = join("/", ["/rds", var.db_identifier, var.db_engine])
  replica_db_parameters_prefix = join("/", ["/rds", local.replica_db_identifier, coalesce(var.replica_engine, var.engine)])
  efs_parameters_prefix        = join("/", ["/efs", var.efs_name])
}

##################################################
#       Primary Database Parameters
##################################################
module "primary_db_parameters" {
  source = "shamimice03/ssm-parameter/aws"

  parameters = [
    {
      name        = join("/", [local.primary_db_parameters_prefix, "DBUser"])
      type        = "String"
      description = "Database Username"
      value       = module.rds.db_instance_username
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.primary_db_parameters_prefix, "DBName"])
      type        = "String"
      description = "Initial Database Name"
      value       = module.rds.db_name
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.primary_db_parameters_prefix, "DBEndpoint"])
      type        = "String"
      description = "Database Instance Endpoint"
      value       = module.rds.db_instance_endpoint
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.primary_db_parameters_prefix, "DBHostname"])
      type        = "String"
      description = "Database Instance Hostname"
      value       = module.rds.db_instance_address
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.primary_db_parameters_prefix, "DBPort"])
      type        = "String"
      description = "Database Instance Port"
      value       = module.rds.db_instance_port
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.primary_db_parameters_prefix, "DBPassword"])
      type        = "SecureString"
      description = "Database password"
      value       = module.rds.db_instance_password
      key_alias   = "alias/aws/ssm"
      tags        = var.general_tags
    },
  ]
}

##################################################
#       Replica Database Parameters
##################################################
module "replica_db_parameters" {
  source = "shamimice03/ssm-parameter/aws"

  parameters = [
    {
      name        = join("/", [local.replica_db_parameters_prefix, "DBUser"])
      type        = "String"
      description = "Database Username"
      value       = module.rds_replica.db_instance_username
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.replica_db_parameters_prefix, "DBName"])
      type        = "String"
      description = "Initial Database Name"
      value       = module.rds_replica.db_name
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.replica_db_parameters_prefix, "DBEndpoint"])
      type        = "String"
      description = "Database Instance Endpoint"
      value       = module.rds_replica.db_instance_endpoint
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.replica_db_parameters_prefix, "DBHostname"])
      type        = "String"
      description = "Database Instance Hostname"
      value       = module.rds_replica.db_instance_address
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.replica_db_parameters_prefix, "DBPort"])
      type        = "String"
      description = "Database Instance Port"
      value       = module.rds_replica.db_instance_port
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.replica_db_parameters_prefix, "DBPassword"])
      type        = "SecureString"
      description = "Database password"
      value       = module.rds_replica.db_instance_password
      key_alias   = "alias/aws/ssm"
      tags        = var.general_tags
    },
  ]
}


##################################################
#   Elastic File System
##################################################
module "efs" {
  source                              = "./modules/efs"
  name                                = var.efs_name
  efs_mount_target_subnet_ids         = module.vpc.private_subnet_id
  efs_mount_target_security_group_ids = [aws_security_group.efs_sg.id]
  efs_encrypted                       = true
  efs_throughput_mode                 = "bursting"
  efs_performance_mode                = "generalPurpose"
  efs_transition_to_ia                = "AFTER_30_DAYS"

  efs_tags = merge(
    { "Name" = var.efs_name },
    var.general_tags,
  )
}

##################################################
#       EFS Parameters
##################################################
module "efs_parameters" {

  source = "shamimice03/ssm-parameter/aws"

  parameters = [
    {
      name        = join("/", [local.efs_parameters_prefix, "EFSID"])
      type        = "String"
      description = "The ID that identifies the file system"
      value       = module.efs.id
      tags        = var.general_tags
    },
  ]
}
