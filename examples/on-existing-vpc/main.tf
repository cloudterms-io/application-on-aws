# existing `vpc` and `subnet` info can be provided like this:
locals {
  vpc_id = "vpc-0d04ecefce33f5303"
  public_subnet_id = [
    "subnet-0914d734033a47ea7",
    "subnet-0e3505b8af912b6fc",
  ]

  intra_subnet_id = [
    "subnet-039221c488d974e9e",
    "subnet-04b62f8d587ed80a1",
  ]

  db_subnet_id = [
    "subnet-0385af6e7dd1cb44c",
    "subnet-089223c210137d902",
  ]

  alb_sg = [module.alb_sg.security_group_id]
  ssh_sg = [module.ssh_sg.security_group_id]
}

# adding external security groups
# following security group will be merged with the security groups created as part of the `aws_ref` module
module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  create = true

  vpc_id      = local.vpc_id
  name        = "alb-icmp"
  description = "alb-icmp access"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-icmp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-icmp"]

}


module "ssh_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  create = true

  vpc_id      = local.vpc_id
  name        = "ssh-access-from-my-ip"
  description = "SSH access from my IP"

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["60.78.9.38/32"]

  egress_rules       = ["ssh-tcp"]
  egress_cidr_blocks = ["60.78.9.38/32"]
}

##################### Main part starts from here #####################
### Retriving Account ID
data "aws_caller_identity" "current" {}

module "aws_ref" {
  source = "../../"

  project_name = "aws-ref-architecture"
  general_tags = {
    "Project_name" = "aws-ref-architecture"
    "Team"         = "platform-team"
    "Env"          = "dev"
  }

  ### VPC
  create_vpc = false # VPC won't created as part of this module
  vpc_id     = local.vpc_id

  ### Security Groups
  create_alb_sg = true
  alb_sg_name   = "aws-ref-alb-sg"

  create_ec2_sg = true
  ec2_sg_name   = "aws-ref-ec2-sg"

  create_efs_sg = true
  efs_sg_name   = "aws-ref-efs-sg"

  create_rds_sg = true
  rds_sg_name   = "aws-ref-rds-sg"

  create_ssh_sg    = true
  ssh_sg_name      = "aws-ref-ssh-sg"
  ssh_ingress_cidr = ["15.168.105.160/29"]

  ### Primary Database
  create_primary_database             = true
  db_identifier                       = "aws-ref-db"
  create_db_subnet_group              = true
  db_subnet_group_name                = "aws-ref-db-subnet"
  db_subnets                          = local.db_subnet_id # on existing db subnet
  db_name                             = "userlist"
  db_master_username                  = "admin"
  multi_az                            = false
  master_db_availability_zone         = "ap-northeast-3a"
  engine                              = "mysql"
  engine_version                      = "8.0"
  instance_class                      = "db.t3.micro"
  storage_type                        = "gp2"
  allocated_storage                   = "20"
  max_allocated_storage               = "20"
  publicly_accessible                 = false
  database_port                       = 3306
  backup_retention_period             = 7
  backup_window                       = "03:00-05:00"
  maintenance_window                  = "Sat:05:00-Sat:07:00"
  deletion_protection                 = false
  iam_database_authentication_enabled = false
  enabled_cloudwatch_logs_exports     = ["audit", "error"]
  apply_immediately                   = true
  delete_automated_backups            = true
  skip_final_snapshot                 = true

  ### Replica Database
  create_replica_database = true
  replica_db_identifier   = "aws-ref-db-replica"
  replica_multi_az        = false

  # following inputs can be skipped. If skipped, settings will be inherited from Primary Database
  replica_db_availability_zone                = "ap-northeast-3b"
  replica_engine                              = "mysql"
  replica_engine_version                      = "8.0"
  replica_instance_class                      = "db.t3.micro"
  replica_storage_type                        = "gp2"
  replica_max_allocated_storage               = "20"
  replica_publicly_accessible                 = false
  replica_database_port                       = 3306
  replica_backup_retention_period             = 7
  replica_backup_window                       = "03:00-05:00"
  replica_maintenance_window                  = "Sat:05:00-Sat:07:00"
  replica_deletion_protection                 = false
  replica_iam_database_authentication_enabled = false
  replica_enabled_cloudwatch_logs_exports     = ["audit", "error"]
  replica_apply_immediately                   = true
  replica_delete_automated_backups            = true
  replica_skip_final_snapshot                 = true

  ### Elastic File System
  efs_create                  = true
  efs_name                    = "aws-ref-efs"
  efs_mount_target_subnet_ids = local.intra_subnet_id # on existing intra subnet
  efs_throughput_mode         = "bursting"
  efs_performance_mode        = "generalPurpose"
  efs_transition_to_ia        = "AFTER_30_DAYS"

  ### Parameters
  create_primary_db_parameters = false
  create_replica_db_parameters = false
  create_efs_parameters        = false

  ### Launch Template
  create_launch_template                 = true
  launch_template_image_id               = "ami-06a5510b6aff4e358"
  launch_template_instance_type          = "t3.micro"
  launch_template_key_name               = "ec2-access" # key-pair must be existed on the respective region
  launch_template_sg_ids                 = local.ssh_sg # adding external SSH security group
  launch_template_update_default_version = true
  launch_template_device_name            = "/dev/xvda"
  launch_template_volume_size            = 20
  launch_template_volume_type            = "gp2"
  launch_template_delete_on_termination  = true
  launch_template_enable_monitoring      = false
  launch_template_userdata_file_path     = "examples/on-existing-vpc/init.sh"
  launch_template_resource_type          = "instance"


  ### ACM - Route53
  create_certificates = true
  acm_domain_names = [
    "fun.kubecloud.net",
    "www.fun.kubecloud.net",
  ]
  acm_hosted_zone_name       = "kubecloud.net"
  acm_validation_method      = "DNS"
  acm_private_zone           = false
  acm_allow_record_overwrite = true
  acm_ttl                    = 60

  ### ALB
  create_lb                       = true
  alb_name_prefix                 = "awsref"
  load_balancer_type              = "application"
  alb_subnets                     = local.public_subnet_id # on existing public subnet
  alb_security_groups             = local.alb_sg           # adding external ALB security group
  alb_target_group_name_prefix    = "ref-tg"
  alb_acm_certificate_domain_name = "fun.kubecloud.net"

  ### ALB - Route5
  create_alb_route53_record = true

  # if `record name` and `zone name` is not provided. It will be fetched from `ACM-Route53`
  alb_route53_record_names = [
    "fun.kubecloud.net",
    "www.fun.kubecloud.net",
  ]
  alb_route53_zone_name              = "kubecloud.net"
  alb_route53_record_type            = "A"
  alb_route53_private_zone           = false
  alb_route53_evaluate_target_health = true
  alb_route53_allow_record_overwrite = true

  ### Custom Policy
  create_custom_policy          = true
  custom_iam_policy_name_prefix = "ListAllS3Buckets"
  custom_iam_policy_path        = "/"
  custom_iam_policy_description = "List all s3 buckets"
  custom_iam_policy_json        = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "s3:ListAllMyBuckets",
        "Resource": "*"
      }
    ]
}
EOF

  ### IAM Instance Profile
  create_instance_profile                = true
  instance_profile_role_name             = "aws-ref-instance-role"
  instance_profile_instance_profile_name = "aws-ref-instance-role"
  instance_profile_role_path             = "/"
  instance_profile_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy",
  ]
  instance_profile_custom_policy_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/AllowFromJapan",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/AllowFromJapanAndGlobalServices",
  ]

  ### Auto Scaling
  asg_create                    = true
  asg_name                      = "aws-ref-asg"
  asg_vpc_zone_identifier       = local.public_subnet_id # on existing public subnet
  asg_desired_capacity          = 2
  asg_min_size                  = 2
  asg_max_size                  = 4
  asg_wait_for_capacity_timeout = "10m"
  asg_health_check_type         = "ELB"
  asg_health_check_grace_period = 300
  asg_enable_monitoring         = true
}
