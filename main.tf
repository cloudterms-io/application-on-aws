#################################################
#   VPC
#################################################
module "vpc" {

  source = "shamimice03/vpc/aws"

  vpc_name = "aws-ref-arch-vpc"
  cidr     = "10.3.0.0/16"

  azs                 = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnet_cidr  = ["10.3.0.0/20", "10.3.16.0/20", "10.3.32.0/20"]
  private_subnet_cidr = ["10.3.48.0/20", "10.3.64.0/20", "10.3.80.0/20"]
  db_subnet_cidr      = ["10.3.96.0/20", "10.3.112.0/20", "10.3.128.0/20"]

  enable_dns_hostnames      = true
  enable_dns_support        = true
  enable_single_nat_gateway = false

  tags = merge(
    { "Name" = var.vpc_name },
    var.general_tags,
  )
}

####################################
#    RDS
####################################

module "rds" {
  source = "shamimice03/rds-blueprint/aws"

  # DB Subnet Group
  create_db_subnet_group = true
  db_subnet_group_name   = "aws-ref-arch-db-subnet"
  db_subnets             = module.vpc.db_subnet_id

  # Identify DB instance
  db_identifier = var.db_identifier

  # Create Initial Database
  db_name = "userlist"

  # Credentials Settings
  # password will be auto generated
  db_master_username                  = "admin"
  iam_database_authentication_enabled = false

  # Availability and durability
  multi_az = false

  # Engine options
  engine         = "mysql"
  engine_version = "8.0"

  # DB Instance configurations
  instance_class = "db.t3.micro"

  # Storage
  storage_type          = "gp2"
  allocated_storage     = "20"
  max_allocated_storage = "20"

  # Connectivity
  db_security_groups  = [aws_security_group.rds_sg.id]
  publicly_accessible = false
  database_port       = 3306

  # Backup and Maintenance
  backup_retention_period = 7
  backup_window           = "03:00-05:00"
  maintenance_window      = "Sat:05:00-Sat:07:00"
  deletion_protection     = false

  # Monitoring
  enabled_cloudwatch_logs_exports = ["audit", "error"]

  # Others
  apply_immediately        = true
  delete_automated_backups = true
  skip_final_snapshot      = true

  tags = merge(
    { "Name" = var.db_identifier },
    var.general_tags,
  )

}

locals {
  db_parameters_prefix  = join("/", ["/rds", var.db_identifier, var.db_engine])
  efs_parameters_prefix = join("/", ["/efs", var.efs_name])
}

#################################################
#       DB Parameters
#################################################
module "db_parameters" {

  source = "shamimice03/ssm-parameter/aws"

  parameters = [
    {
      name        = join("/", [local.db_parameters_prefix, "DBUser"])
      type        = "String"
      description = "Database Username"
      value       = module.rds.db_instance_username
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.db_parameters_prefix, "DBName"])
      type        = "String"
      description = "Initial Database Name"
      value       = module.rds.db_name
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.db_parameters_prefix, "DBEndpoint"])
      type        = "String"
      description = "Database Instance Endpoint"
      value       = module.rds.db_instance_endpoint
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.db_parameters_prefix, "DBHostname"])
      type        = "String"
      description = "Database Instance Hostname"
      value       = module.rds.db_instance_address
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.db_parameters_prefix, "DBPort"])
      type        = "String"
      description = "Database Instance Port"
      value       = module.rds.db_instance_port
      tags        = var.general_tags
    },
    {
      name        = join("/", [local.db_parameters_prefix, "DBPassword"])
      type        = "SecureString"
      description = "Database password"
      value       = module.rds.db_instance_password
      key_alias   = "alias/aws/ssm"
      tags        = var.general_tags
    },
  ]
}

####################################
#   EFS
####################################
module "efs" {
  source               = "./modules/efs"
  name                 = var.efs_name
  efs_subnet_ids       = module.vpc.private_subnet_id
  security_group_ids   = [aws_security_group.efs_sg.id]
  efs_encrypted        = true
  efs_throughput_mode  = "bursting"
  efs_performance_mode = "generalPurpose"
  efs_transition_to_ia = "AFTER_30_DAYS"

  efs_tags = merge(
    { "Name" = var.efs_name },
    var.general_tags,
  )
}

#################################################
#       EFS Parameters
#################################################
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
