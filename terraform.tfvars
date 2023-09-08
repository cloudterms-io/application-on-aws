project_name = "aws-ref-architecture"
general_tags = {
  "Project_name" = "aws-ref-architecture"
  "Team"         = "platform-team"
  "Env"          = "dev"
}
### VPC
vpc_name                  = "aws-ref-vpc"
cidr                      = "10.3.0.0/16"
azs                       = ["ap-northeast-1a", "ap-northeast-1c"]
public_subnet_cidr        = ["10.3.0.0/20", "10.3.16.0/20"]
private_subnet_cidr       = ["10.3.32.0/20", "10.3.48.0/20"]
db_subnet_cidr            = ["10.3.64.0/20", "10.3.80.0/20"]
enable_dns_hostnames      = true
enable_dns_support        = true
enable_single_nat_gateway = false

### Security Groups
create_alb_sg = true
alb_sg_name   = "aws-ref-alb-sg"

create_ec2_sg = true
ec2_sg_name   = "aws-ref-ec2-sg"

create_efs_sg = true
efs_sg_name   = "aws-ref-efs-sg"

create_rds_sg = true
rds_sg_name   = "aws-ref-rds-sg"

create_ssh_sg = true
ssh_sg_name   = "aws-ref-ssh-sg"

### Primary Database
db_identifier                       = "aws-ref-db"
create_db_subnet_group              = true
db_subnet_group_name                = "aws-ref-db-subnet"
db_subnets                          = [] # This will be populated by module.vpc.db_subnet_id
db_name                             = "userlist"
db_master_username                  = "admin"
multi_az                            = false
master_db_availability_zone         = "ap-northeast-1a"
engine                              = "mysql"
engine_version                      = "8.0"
instance_class                      = "db.t3.micro"
storage_type                        = "gp2"
allocated_storage                   = "20"
max_allocated_storage               = "20"
db_security_groups                  = [] # This will be populated by module.rds_sg.security_group_id
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
replica_db_identifier                       = "aws-ref-db-replica"
replica_multi_az                            = false
replica_db_availability_zone                = "ap-northeast-1c"
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
efs_name                            = "aws-ref-efs"
efs_mount_target_subnet_ids         = [] # This will be populated by module.vpc.private_subnet_id
efs_mount_target_security_group_ids = [] # This will be populated by module.efs_sg.security_group_id
efs_throughput_mode                 = "bursting"
efs_performance_mode                = "generalPurpose"
efs_transition_to_ia                = "AFTER_30_DAYS"

### Launch Template                           
launch_template_image_id               = "" # This will be populated by data.aws_ami.amazonlinux2.id
launch_template_instance_type          = "t2.micro"
launch_template_key_name               = "ec2-access"
launch_template_sg_ids                 = [] # This will be populated by [module.ec2_sg.security_group_id, module.ssh_sg.security_group_id]
launch_template_update_default_version = true
launch_template_name_prefix            = "aws-ref"
launch_template_device_name            = "/dev/sda1"
launch_template_volume_size            = 20
launch_template_volume_type            = "gp2"
launch_template_delete_on_termination  = true
launch_template_enable_monitoring      = false
launch_template_userdata_file_path     = "userdata.sh"
launch_template_resource_type          = "instance"

### ACM - Route53
acm_domain_name            = "demo.kubecloud.net"
acm_validation_method      = "DNS"
acm_hosted_zone_name       = "kubecloud.net"
acm_private_zone           = false
acm_allow_record_overwrite = true
acm_ttl                    = 60

### ALB
alb_name_prefix              = "awsref"
load_balancer_type           = "application"
alb_subnets                  = [] # This will be populated by module.vpc.public_subnet_id,
alb_security_groups          = [] # This will be populated by module.alb_sg.security_group_id
alb_target_group_name_prefix = "ref-tg"
alb_certificate_arn          = "" # This will be populated by module.acm_route53.certificate_arn

### ALB - Route53
alb_route53_zone_name              = "kubecloud.net."
alb_route53_record_name_1          = "demo.kubecloud.net"
alb_route53_record_name_2          = "www.demo.kubecloud.net"
alb_route53_record_type            = "A"
alb_route53_private_zone           = false
alb_route53_evaluate_target_health = true

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
instance_profile_create_instance_profile = true
instance_profile_role_name               = "aws-ref-instance-role"
instance_profile_instance_profile_name   = "aws-ref-instance-role"
instance_profile_managed_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess",
  "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy",
]
instance_profile_custom_policy_arns = [
  "arn:aws:iam::391178969547:policy/AllowFromJapan",
  "arn:aws:iam::391178969547:policy/AllowFromJapanAndGlobalServices",
]
instance_profile_role_path = "/"

### Auto Scaling
asg_name                      = "aws-ref-asg"
asg_vpc_zone_identifier       = [] # This will be populated by module.vpc.public_subnet_id
asg_desired_capacity          = 2
asg_min_size                  = 2
asg_max_size                  = 4
asg_wait_for_capacity_timeout = 0
asg_health_check_type         = "ELB"
asg_health_check_grace_period = 300
asg_enable_monitoring         = true
