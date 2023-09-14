######################################################
#                        VPC
######################################################
module "vpc" {
  source = "shamimice03/vpc/aws"

  create = var.create_vpc

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

######################################################
#                     Security Groups
######################################################
locals {
  vpc_id = module.vpc.vpc_id

  alb_sg_description = "Allow HTTP and HTTPS traffic from anywhere"
  ec2_sg_description = "Allow inbound traffic from ALB"
  efs_sg_description = "Allow inbound traffic from ec2-sg"
  rds_sg_description = "Allow inbound traffic from ec2-sg"
  ssh_sg_description = "Allow SSH from anywhere"

  alb_sg_name = coalesce(var.alb_sg_name, "alb-sg")
  ec2_sg_name = coalesce(var.ec2_sg_name, "ec2-sg")
  efs_sg_name = coalesce(var.efs_sg_name, "efs-sg")
  rds_sg_name = coalesce(var.rds_sg_name, "rds-sg")
  ssh_sg_name = coalesce(var.ssh_sg_name, "ssh-sg")

  create_alb_sg = var.create_vpc && var.create_alb_sg
  create_ec2_sg = var.create_vpc && var.create_ec2_sg
  create_efs_sg = var.create_vpc && var.create_efs_sg
  create_rds_sg = var.create_vpc && var.create_rds_sg
  create_ssh_sg = var.create_vpc && var.create_ssh_sg
}

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create = local.create_alb_sg

  vpc_id      = local.vpc_id
  name        = local.alb_sg_name
  description = local.alb_sg_description

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create = local.create_ec2_sg

  vpc_id      = local.vpc_id
  name        = local.ec2_sg_name
  description = local.ec2_sg_description

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb_sg.security_group_id
    },
  ]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

module "efs_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create = local.create_efs_sg

  vpc_id      = local.vpc_id
  name        = local.efs_sg_name
  description = local.efs_sg_description

  ingress_with_source_security_group_id = [
    {
      rule                     = "nfs-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    },
  ]

  egress_with_source_security_group_id = [
    {
      rule                     = "nfs-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    },
  ]
}

module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create = local.create_rds_sg

  vpc_id      = local.vpc_id
  name        = local.rds_sg_name
  description = local.rds_sg_description

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    },
  ]

  egress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    },
  ]
}

module "ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create = local.create_ssh_sg

  vpc_id      = local.vpc_id
  name        = local.ssh_sg_name
  description = local.ssh_sg_description

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["ssh-tcp"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

##################################################
#    Primary Database
##################################################
locals {
  rds_security_groups = [module.rds_sg.security_group_id]
}

module "rds" {
  source = "shamimice03/rds-blueprint/aws"

  create = var.create_primary_database

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
  db_security_groups  = coalesce(local.rds_security_groups, var.db_security_groups)
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
locals {
  replica_db_identifier   = coalesce(var.replica_db_identifier, join("-", [var.db_identifier, "replica"]))
  create_replica_database = var.create_primary_database && var.create_replica_database
}

module "rds_replica" {
  source = "shamimice03/rds-blueprint/aws"

  create = local.create_replica_database

  replicate_source_db                 = var.db_identifier
  db_identifier                       = coalesce(var.replica_db_identifier, local.replica_db_identifier)
  multi_az                            = coalesce(var.replica_multi_az, var.multi_az)
  availability_zone                   = coalesce(var.replica_db_availability_zone, var.master_db_availability_zone)
  engine                              = coalesce(var.replica_engine, var.engine)
  engine_version                      = coalesce(var.replica_engine_version, var.engine_version)
  instance_class                      = coalesce(var.replica_instance_class, var.instance_class)
  iam_database_authentication_enabled = coalesce(var.replica_iam_database_authentication_enabled, var.iam_database_authentication_enabled)
  storage_type                        = coalesce(var.replica_storage_type, var.storage_type)
  max_allocated_storage               = coalesce(var.replica_max_allocated_storage, var.max_allocated_storage)
  db_security_groups                  = coalesce(local.rds_security_groups, var.db_security_groups)
  publicly_accessible                 = coalesce(var.replica_publicly_accessible, var.publicly_accessible)
  database_port                       = coalesce(var.replica_database_port, var.database_port)
  backup_retention_period             = coalesce(var.replica_backup_retention_period, var.backup_retention_period)
  backup_window                       = coalesce(var.replica_backup_window, var.backup_window)
  maintenance_window                  = coalesce(var.replica_maintenance_window, var.maintenance_window)
  deletion_protection                 = coalesce(var.replica_deletion_protection, var.deletion_protection)
  enabled_cloudwatch_logs_exports     = coalesce(var.replica_enabled_cloudwatch_logs_exports, var.enabled_cloudwatch_logs_exports)
  apply_immediately                   = coalesce(var.replica_apply_immediately, var.apply_immediately)
  delete_automated_backups            = coalesce(var.replica_delete_automated_backups, var.delete_automated_backups)
  skip_final_snapshot                 = coalesce(var.replica_skip_final_snapshot, var.skip_final_snapshot)

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
  primary_db_parameters_prefix = join("/", ["/rds", var.db_identifier, var.engine])
  replica_db_parameters_prefix = join("/", ["/rds", local.replica_db_identifier, coalesce(var.replica_engine, var.engine)])
  efs_parameters_prefix        = join("/", ["/efs", var.efs_name])
}

##################################################
#       Primary Database Parameters
##################################################
locals {
  create_primary_db_parameters = var.create_primary_database && var.create_primary_db_parameters
}

module "primary_db_parameters" {
  source = "shamimice03/ssm-parameter/aws"

  parameters = [
    {
      create      = local.create_primary_db_parameters
      name        = join("/", [local.primary_db_parameters_prefix, "DBUser"])
      type        = "String"
      description = "Database Username"
      value       = module.rds.db_instance_username
      tags        = var.general_tags
    },
    {
      create      = local.create_primary_db_parameters
      name        = join("/", [local.primary_db_parameters_prefix, "DBName"])
      type        = "String"
      description = "Initial Database Name"
      value       = module.rds.db_name
      tags        = var.general_tags
    },
    {
      create      = local.create_primary_db_parameters
      name        = join("/", [local.primary_db_parameters_prefix, "DBEndpoint"])
      type        = "String"
      description = "Database Instance Endpoint"
      value       = module.rds.db_instance_endpoint
      tags        = var.general_tags
    },
    {
      create      = local.create_primary_db_parameters
      name        = join("/", [local.primary_db_parameters_prefix, "DBHostname"])
      type        = "String"
      description = "Database Instance Hostname"
      value       = module.rds.db_instance_address
      tags        = var.general_tags
    },
    {
      create      = local.create_primary_db_parameters
      name        = join("/", [local.primary_db_parameters_prefix, "DBPort"])
      type        = "String"
      description = "Database Instance Port"
      value       = module.rds.db_instance_port
      tags        = var.general_tags
    },
    {
      create      = local.create_primary_db_parameters
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
locals {
  create_replica_db_parameters = var.create_primary_database && var.create_replica_database && var.create_replica_db_parameters
}

module "replica_db_parameters" {
  source = "shamimice03/ssm-parameter/aws"

  parameters = [
    {
      create      = local.create_replica_db_parameters
      name        = join("/", [local.replica_db_parameters_prefix, "DBUser"])
      type        = "String"
      description = "Database Username"
      value       = module.rds_replica.db_instance_username
      tags        = var.general_tags
    },
    {
      create      = local.create_replica_db_parameters
      name        = join("/", [local.replica_db_parameters_prefix, "DBName"])
      type        = "String"
      description = "Initial Database Name"
      value       = module.rds_replica.db_name
      tags        = var.general_tags
    },
    {
      create      = local.create_replica_db_parameters
      name        = join("/", [local.replica_db_parameters_prefix, "DBEndpoint"])
      type        = "String"
      description = "Database Instance Endpoint"
      value       = module.rds_replica.db_instance_endpoint
      tags        = var.general_tags
    },
    {
      create      = local.create_replica_db_parameters
      name        = join("/", [local.replica_db_parameters_prefix, "DBHostname"])
      type        = "String"
      description = "Database Instance Hostname"
      value       = module.rds_replica.db_instance_address
      tags        = var.general_tags
    },
    {
      create      = local.create_replica_db_parameters
      name        = join("/", [local.replica_db_parameters_prefix, "DBPort"])
      type        = "String"
      description = "Database Instance Port"
      value       = module.rds_replica.db_instance_port
      tags        = var.general_tags
    },
    {
      create      = local.create_replica_db_parameters
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
locals {
  efs_mount_target_subnet_ids         = coalesce(module.vpc.private_subnet_id, var.efs_mount_target_subnet_ids)
  efs_mount_target_security_group_ids = coalesce([module.efs_sg.security_group_id], var.efs_mount_target_security_group_ids)
}


module "efs" {
  source = "./modules/efs"

  create                              = var.efs_create
  name                                = var.efs_name
  efs_mount_target_subnet_ids         = local.efs_mount_target_subnet_ids
  efs_mount_target_security_group_ids = local.efs_mount_target_security_group_ids
  efs_encrypted                       = var.efs_encrypted
  efs_throughput_mode                 = var.efs_throughput_mode
  efs_performance_mode                = var.efs_performance_mode
  efs_transition_to_ia                = var.efs_transition_to_ia

  efs_tags = merge(
    { "Name" = var.efs_name },
    var.general_tags,
  )
}

##################################################
#       EFS Parameters
##################################################
locals {
  create_efs_parameters = var.efs_create && var.create_efs_parameters
}

module "efs_parameters" {

  source = "shamimice03/ssm-parameter/aws"

  parameters = [
    {
      create      = local.create_efs_parameters
      name        = join("/", [local.efs_parameters_prefix, "EFSID"])
      type        = "String"
      description = "The ID that identifies the file system"
      value       = module.efs.id
      tags        = var.general_tags
    },
  ]
}

##################################################
#             Launch Template
##################################################
data "aws_ami" "amazonlinux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*"]
  }
}

locals {
  launch_template_sg_ids                    = coalesce([module.ec2_sg.security_group_id, module.ssh_sg.security_group_id], var.launch_template_sg_ids)
  launch_template_image_id                  = coalesce(var.launch_template_image_id, data.aws_ami.amazonlinux2.id)
  launch_template_name_prefix               = coalesce(var.launch_template_name_prefix, var.project_name)
  launch_template_iam_instance_profile_name = module.instance_profile.profile_name
  launch_template_userdata_file_path        = join("/", [path.module, var.launch_template_userdata_file_path])
}

module "launch_template" {
  source = "./modules/launch-template"

  create = var.launch_template_create_new

  launch_template_name_prefix = local.launch_template_name_prefix
  image_id                    = local.launch_template_image_id
  instance_type               = var.launch_template_instance_type
  key_name                    = var.launch_template_key_name
  update_default_version      = var.launch_template_update_default_version
  vpc_security_group_ids      = local.launch_template_sg_ids
  iam_instance_profile_name   = local.launch_template_iam_instance_profile_name
  device_name                 = var.launch_template_device_name
  volume_size                 = var.launch_template_volume_size
  volume_type                 = var.launch_template_volume_type
  delete_on_termination       = var.launch_template_delete_on_termination
  enable_monitoring           = var.launch_template_enable_monitoring
  user_data_file_path         = filebase64(local.launch_template_userdata_file_path)

  # tag_specifications
  resource_type = var.launch_template_resource_type
  tags = merge(
    { "Name" = local.launch_template_name_prefix },
    var.general_tags,
  )
}

##################################################
#             ACM - Route53
##################################################
module "acm_route53" {

  source = "shamimice03/acm-route53/aws"

  domain_name            = var.acm_domain_name
  validation_method      = var.acm_validation_method
  hosted_zone_name       = var.acm_hosted_zone_name
  private_zone           = var.acm_private_zone
  allow_record_overwrite = var.acm_allow_record_overwrite
  ttl                    = var.acm_ttl
  tags = merge(
    { "Name" = var.acm_domain_name },
    var.general_tags,
  )
}

module "acm_route53_www" {

  source = "shamimice03/acm-route53/aws"

  domain_name            = var.acm_domain_name_www
  validation_method      = var.acm_validation_method
  hosted_zone_name       = var.acm_hosted_zone_name
  private_zone           = var.acm_private_zone
  allow_record_overwrite = var.acm_allow_record_overwrite
  ttl                    = var.acm_ttl
  tags = merge(
    { "Name" = var.acm_domain_name_www },
    var.general_tags,
  )
}

##################################################
#                  ALB
##################################################
locals {
  alb_subnets                  = coalesce(module.vpc.public_subnet_id, var.alb_subnets)
  alb_security_groups          = coalesce([module.alb_sg.security_group_id], var.alb_security_groups)
  alb_name_prefix              = coalesce(var.alb_name_prefix, "refalb")
  alb_target_group_name_prefix = coalesce(var.alb_target_group_name_prefix, "ref-tg")
  alb_certificate_arn          = module.acm_route53.certificate_arn
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  create_lb          = var.create_lb
  name_prefix        = local.alb_name_prefix
  load_balancer_type = var.load_balancer_type
  vpc_id             = local.vpc_id
  subnets            = local.alb_subnets
  security_groups    = local.alb_security_groups

  #  access_logs = {
  #     bucket = "my-alb-logs"
  #  }

  target_groups = [
    {
      name_prefix      = local.alb_target_group_name_prefix
      target_type      = "instance"
      backend_port     = 80
      backend_protocol = "HTTP"
      protocol_version = "HTTP1"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = local.alb_certificate_arn
      action_type        = "forward"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  tags = merge(
    { "Name" = local.alb_name_prefix },
    var.general_tags,
  )
}

##################################################
#                  ALB - route53
##################################################
locals {
  alb_dns_name = module.alb.lb_dns_name
  alb_zone_id  = module.alb.lb_zone_id

  alb_route53_record_name     = coalesce(var.alb_route53_record_name, var.acm_domain_name)
  alb_route53_record_name_www = coalesce(var.alb_route53_record_name_www, var.acm_domain_name_www)
  alb_route53_zone_name       = coalesce(var.alb_route53_zone_name, var.acm_hosted_zone_name)

}

module "alb_route53_record" {
  source                 = "./modules/alb-route53"
  create_record          = var.create_alb_route53_record
  zone_name              = local.alb_route53_zone_name
  record_name            = local.alb_route53_record_name
  record_type            = var.alb_route53_record_type
  lb_dns_name            = local.alb_dns_name
  lb_zone_id             = local.alb_zone_id
  private_zone           = var.alb_route53_private_zone
  evaluate_target_health = var.alb_route53_evaluate_target_health
}

module "alb_route53_record_www" {
  source                 = "./modules/alb-route53"
  create_record          = var.create_alb_route53_www_record
  zone_name              = local.alb_route53_zone_name
  record_name            = local.alb_route53_record_name_www
  record_type            = var.alb_route53_record_type
  lb_dns_name            = local.alb_dns_name
  lb_zone_id             = local.alb_zone_id
  private_zone           = var.alb_route53_private_zone
  evaluate_target_health = var.alb_route53_evaluate_target_health
}

#######################################
# Create custom policy
#######################################
module "custom_iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  create_policy = var.create_custom_policy

  name_prefix = var.custom_iam_policy_name_prefix
  path        = var.custom_iam_policy_path
  description = coalesce(var.custom_iam_policy_description, var.custom_iam_policy_name_prefix)

  policy = var.custom_iam_policy_json

  tags = merge(
    { "Type" = "Custom-Policy" },
    var.general_tags,
  )
}

#######################################
# IAM Instance profile
#######################################
locals {
  instance_profile_custom_policy_arns       = compact(concat(var.instance_profile_custom_policy_arns, [module.custom_iam_policy.arn]))
  instance_profile_custom_policy_arns_count = length(var.instance_profile_custom_policy_arns) + (var.create_custom_policy ? 1 : 0)
}

module "instance_profile" {

  source = "./modules/iam-instance-profile"

  create_instance_profile  = var.instance_profile_create_instance_profile
  role_name                = var.instance_profile_role_name
  instance_profile_name    = var.instance_profile_instance_profile_name
  managed_policy_arns      = var.instance_profile_managed_policy_arns
  custom_policy_arns       = local.instance_profile_custom_policy_arns
  custom_policy_arns_count = local.instance_profile_custom_policy_arns_count
  role_path                = var.instance_profile_role_path

  depends_on = [module.custom_iam_policy]
}

##################################################
#                  Auto-Scaling
##################################################
locals {
  asg_launch_template_name    = coalesce(module.launch_template.name, var.asg_launch_template_name)
  asg_launch_template_version = coalesce(module.launch_template.latest_version, var.asg_launch_template_version)
  asg_vpc_zone_identifier     = coalesce(module.vpc.public_subnet_id, var.asg_vpc_zone_identifier)
  asg_name                    = coalesce(var.asg_name, join("-", [var.project_name, "asg"]))
  asg_target_group_arns       = module.alb.target_group_arns
}

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"
  create = true
  # Do not create launch template using asg module.
  # `launch template` created separately using `launch template` module or pre-existing template
  create_launch_template = false

  name                    = local.asg_name
  launch_template         = local.asg_launch_template_name
  launch_template_version = local.asg_launch_template_version
  vpc_zone_identifier     = local.asg_vpc_zone_identifier

  desired_capacity = var.asg_desired_capacity
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size

  target_group_arns = local.asg_target_group_arns

  wait_for_capacity_timeout = var.asg_wait_for_capacity_timeout
  health_check_type         = var.asg_health_check_type
  health_check_grace_period = var.asg_health_check_grace_period

  enable_monitoring = var.asg_enable_monitoring

  tags = merge(
    { "Name" = local.asg_name },
    var.general_tags,
  )
}
