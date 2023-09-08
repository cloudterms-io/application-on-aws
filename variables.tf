variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "aws-ref-architecture"
  nullable    = false
}

variable "general_tags" {
  description = "General tags to apply to resources created"
  type        = map(string)
  default = {
    "Project_name" = "aws-ref-architecture"
    "Team"         = "platform-team"
    "Env"          = "dev"
  }
}

######################## VPC ########################
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "aws-ref-arch-vpc"
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.3.0.0/16"
}

variable "azs" {
  description = "Availability Zones for subnets"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "public_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.3.0.0/20", "10.3.16.0/20"]
}

variable "private_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.3.32.0/20", "10.3.48.0/20"]
}

variable "db_subnet_cidr" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.3.64.0/20", "10.3.80.0/20"]
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS resolution for the VPC"
  type        = bool
  default     = true
}

variable "enable_single_nat_gateway" {
  description = "Enable a single NAT gateway for all private subnets"
  type        = bool
  default     = false
}

######################## Secuirity Groups ########################
variable "create_alb_sg" {
  description = "Whether to create the Application Load Balancer (ALB) security group."
  type        = bool
  default     = true
}

variable "alb_sg_name" {
  description = "Name of the ALB security group"
  type        = string
  default     = "aws-ref-alb-sg"
}

variable "create_ec2_sg" {
  description = "Whether to create the EC2 instance security group."
  type        = bool
  default     = true
}

variable "ec2_sg_name" {
  description = "Name of the ec2 security group"
  type        = string
  default     = "aws-ref-ec2-sg"
}

variable "create_efs_sg" {
  description = "Whether to create the Elastic File System (EFS) security group."
  type        = bool
  default     = true
}

variable "efs_sg_name" {
  description = "Name of the EFS security group"
  type        = string
  default     = "aws-ref-efs-sg"
}

variable "create_rds_sg" {
  description = "Whether to create the RDS security group."
  type        = bool
  default     = true
}

variable "rds_sg_name" {
  description = "Name of the RDS security group"
  type        = string
  default     = "aws-ref-rds-sg"
}

variable "create_ssh_sg" {
  description = "Whether to create the SSH security group."
  type        = bool
  default     = true
}

variable "ssh_sg_name" {
  description = "Name of the SSH security group"
  type        = string
  default     = "aws-ref-ssh-sg"
}

######################## Primary Database ###########################
variable "db_identifier" {
  description = "The name of the RDS instance"
  type        = string
  default     = "aws-ref-arch-db"
}

variable "create_db_subnet_group" {
  description = "Create a new DB subnet group"
  type        = bool
  default     = true
}

variable "db_subnet_group_name" {
  description = "Name for the DB subnet group"
  type        = string
  default     = "aws-ref-arch-db-subnet"
}

variable "db_subnets" {
  description = "List of DB subnets for the RDS instance"
  type        = list(string)
  default     = []
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "userlist"
}

variable "db_master_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "iam_database_authentication_enabled" {
  description = "Enable IAM database authentication"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Enable multi-AZ deployment for the RDS instance"
  type        = bool
  default     = false
}

variable "master_db_availability_zone" {
  description = "Availability zone for the RDS instance"
  type        = string
  default     = "ap-northeast-1a"
}

variable "engine" {
  description = "Database engine type"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "storage_type" {
  description = "Storage type for the RDS instance"
  type        = string
  default     = "gp2"
}

variable "allocated_storage" {
  description = "Allocated storage for the RDS instance (in GB)"
  type        = string
  default     = "20"
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage for the RDS instance (in GB)"
  type        = string
  default     = "20"
}

variable "db_security_groups" {
  description = "List of security group IDs for the RDS instance"
  type        = list(string)
  default     = []
}

variable "publicly_accessible" {
  description = "Make the RDS instance publicly accessible"
  type        = bool
  default     = false
}

variable "database_port" {
  description = "Port for the RDS instance"
  type        = number
  default     = 3306
}

variable "backup_retention_period" {
  description = "Backup retention period (in days) for the RDS instance"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window for the RDS instance"
  type        = string
  default     = "03:00-05:00"
}

variable "maintenance_window" {
  description = "Maintenance window for the RDS instance"
  type        = string
  default     = "Sat:05:00-Sat:07:00"
}

variable "deletion_protection" {
  description = "Enable or disable deletion protection for the RDS instance"
  type        = bool
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of CloudWatch logs to export for the RDS instance"
  type        = list(string)
  default     = ["audit", "error"]
}

variable "apply_immediately" {
  description = "Apply changes immediately or during the next maintenance window"
  type        = bool
  default     = true
}

variable "delete_automated_backups" {
  description = "Delete automated backups when the RDS instance is deleted"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip the final DB snapshot when the RDS instance is deleted"
  type        = bool
  default     = true
}

######################## Read Replica ########################
variable "replica_db_identifier" {
  description = "Identifier for the RDS replica instance"
  type        = string
  default     = ""
}

variable "replica_multi_az" {
  description = "Enable multi-AZ deployment for the RDS replica instance"
  type        = bool
  default     = null
}

variable "replica_db_availability_zone" {
  description = "Availability zone for the RDS replica instance"
  type        = string
  default     = "ap-northeast-1c"
}

variable "replica_engine" {
  description = "Database engine type for the RDS replica instance"
  type        = string
  default     = ""
}

variable "replica_engine_version" {
  description = "Database engine version for the RDS replica instance"
  type        = string
  default     = ""
}

variable "replica_instance_class" {
  description = "RDS instance class for the replica"
  type        = string
  default     = ""
}

variable "replica_storage_type" {
  description = "Storage type for the RDS replica instance"
  type        = string
  default     = ""
}

variable "replica_max_allocated_storage" {
  description = "Maximum allocated storage for the RDS replica instance (in GB)"
  type        = string
  default     = ""
}

variable "replica_publicly_accessible" {
  description = "Make the RDS replica instance publicly accessible"
  type        = bool
  default     = null
}

variable "replica_database_port" {
  description = "Port for the RDS replica instance"
  type        = number
  default     = null
}

variable "replica_backup_retention_period" {
  description = "Backup retention period (in days) for the RDS replica instance"
  type        = number
  default     = null
}

variable "replica_backup_window" {
  description = "Preferred backup window for the RDS replica instance"
  type        = string
  default     = ""
}

variable "replica_maintenance_window" {
  description = "Maintenance window for the RDS replica instance"
  type        = string
  default     = ""
}

variable "replica_deletion_protection" {
  description = "Enable or disable deletion protection for the RDS replica instance"
  type        = bool
  default     = null
}

variable "replica_iam_database_authentication_enabled" {
  description = "Enable IAM database authentication"
  type        = bool
  default     = null
}

variable "replica_enabled_cloudwatch_logs_exports" {
  description = "List of CloudWatch logs to export for the RDS replica instance"
  type        = list(string)
  default     = []
}

variable "replica_apply_immediately" {
  description = "Apply changes immediately or during the next maintenance window for the replica"
  type        = bool
  default     = null
}

variable "replica_delete_automated_backups" {
  description = "Delete automated backups when the RDS replica instance is deleted"
  type        = bool
  default     = null
}

variable "replica_skip_final_snapshot" {
  description = "Skip the final DB snapshot when the RDS replica instance is deleted"
  type        = bool
  default     = null
}


######################## EFS ########################
variable "efs_name" {
  description = "Name of the Elastic File System"
  type        = string
  default     = "aws-ref-arch-efs"
}

variable "efs_mount_target_subnet_ids" {
  description = "List of subnet IDs for EFS mount targets"
  type        = list(string)
  default     = []
}

variable "efs_mount_target_security_group_ids" {
  description = "List of security group IDs for EFS mount targets"
  type        = list(string)
  default     = []
}

variable "efs_encrypted" {
  description = "Whether to enable encryption for the EFS file system"
  type        = bool
  default     = true
}

variable "efs_throughput_mode" {
  description = "The throughput mode for the EFS file system (e.g., 'bursting' or 'provisioned')"
  type        = string
  default     = "bursting"
}

variable "efs_performance_mode" {
  description = "The performance mode for the EFS file system (e.g., 'generalPurpose' or 'maxIO')"
  type        = string
  default     = "generalPurpose"
}

variable "efs_transition_to_ia" {
  description = "The lifecycle policy transition for files to Infrequent Access (IA) storage"
  type        = string
  default     = "AFTER_30_DAYS"
}

######################## Launch Template ########################
variable "launch_template_image_id" {
  description = "The AMI from which to launch the instance. Default will be `Amazonlinux2`"
  type        = string
  default     = ""
}

variable "launch_template_instance_type" {
  description = "The EC2 instance type for instances launched from the template"
  type        = string
  default     = "t2.micro"
}

variable "launch_template_key_name" {
  description = "The name of the SSH key pair to associate with instances launched from the template"
  type        = string
  default     = "ec2-access"
}

variable "launch_template_update_default_version" {
  description = "Flag to update the default version of the launch template"
  type        = bool
  default     = true
}

variable "launch_template_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = "aws-ref"
}

variable "launch_template_sg_ids" {
  description = "List of security group IDs for the launch template"
  type        = list(string)
  default     = []
}

variable "launch_template_device_name" {
  description = "The device name for the root volume"
  type        = string
  default     = "/dev/sda1"
}

variable "launch_template_volume_size" {
  description = "The size of the root volume for instances launched from the template (in GiB)"
  type        = number
  default     = 20
}

variable "launch_template_volume_type" {
  description = "The type of volume for the root volume (e.g., 'gp2')"
  type        = string
  default     = "gp2"
}

variable "launch_template_delete_on_termination" {
  description = "Whether the root volume should be deleted on instance termination"
  type        = bool
  default     = true
}

variable "launch_template_enable_monitoring" {
  description = "Whether instance monitoring should be enabled"
  type        = bool
  default     = false
}

variable "launch_template_userdata_file_path" {
  description = "Path to the user data script file"
  type        = string
  default     = "userdata.sh"
}

variable "launch_template_resource_type" {
  description = "The type of resource to tag"
  type        = string
  default     = "instance"
}

######################## ACM - Route53 ########################
variable "acm_domain_name" {
  description = "Domain name for ACM certificate"
  type        = string
  default     = "demo.kubecloud.net"
}

variable "acm_validation_method" {
  description = "Validation method for ACM certificate"
  type        = string
  default     = "DNS"
}

variable "acm_hosted_zone_name" {
  description = "Hosted zone name for DNS validation"
  type        = string
  default     = "kubecloud.net"
}

variable "acm_private_zone" {
  description = "Whether the hosted zone is private or not"
  type        = bool
  default     = false
}

variable "acm_allow_record_overwrite" {
  description = "Allow record overwrite in DNS validation"
  type        = bool
  default     = true
}

variable "acm_ttl" {
  description = "Time to live (TTL) for DNS records"
  type        = number
  default     = 60
}


######################## ALB ########################
variable "alb_name_prefix" {
  description = "Prefix for the Application Load Balancer name"
  type        = string
  default     = "awsref"
}

variable "load_balancer_type" {
  description = "Type of the Load Balancer"
  type        = string
  default     = "application"
}

variable "alb_subnets" {
  description = "List of subnet IDs for the Application Load Balancer (ALB)"
  type        = list(string)
  default     = []
}

variable "alb_security_groups" {
  description = "List of security group IDs for the Application Load Balancer (ALB)"
  type        = list(string)
  default     = []
}

variable "alb_target_group_name_prefix" {
  description = "Prefix for the ALB target group name"
  type        = string
  default     = "ref-tg"
}

variable "alb_certificate_arn" {
  description = "ARN of the ACM certificate for the Application Load Balancer (ALB)"
  type        = string
  default     = ""
}

######################### ALB - Route53 ###################
variable "alb_route53_zone_name" {
  description = "The DNS zone name"
  type        = string
  default     = "kubecloud.net."
}

variable "alb_route53_record_name_1" {
  description = "The DNS record name for the first ALB record"
  type        = string
  default     = "demo.kubecloud.net"
}

variable "alb_route53_record_name_2" {
  description = "The DNS record name for the second ALB record"
  type        = string
  default     = "www.demo.kubecloud.net"
}

variable "alb_route53_record_type" {
  description = "The DNS record type for ALB records"
  type        = string
  default     = "A"
}

variable "alb_route53_private_zone" {
  description = "Whether the DNS zone is private or not"
  type        = bool
  default     = false
}

variable "alb_route53_evaluate_target_health" {
  description = "Whether to evaluate the target health of the ALB"
  type        = bool
  default     = true
}

######################## Create custom policy ########################
variable "create_custom_policy" {
  description = "Whether to create custom policy"
  type        = bool
  default     = true
}

variable "custom_iam_policy_name_prefix" {
  description = "Prefix for the IAM policy name. Required if `create_custom_policy` set to `true`"
  type        = string
  default     = "ListAllS3Buckets"
}

variable "custom_iam_policy_path" {
  description = "The path for the IAM policy. Required if `create_custom_policy` set to `true`"
  type        = string
  default     = "/"
}

variable "custom_iam_policy_description" {
  description = "Description for the IAM policy. Required if `create_custom_policy` set to `true`"
  type        = string
  default     = "List all s3 buckets"
}

variable "custom_iam_policy_json" {
  description = "JSON policy document. Required if `create_custom_policy` set to `true`"
  type        = string
  default     = <<EOF
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
}

######################## IAM Instance Profile ########################
variable "instance_profile_create_instance_profile" {
  description = "Whether to create an instance profile"
  type        = bool
  default     = true
}

variable "instance_profile_role_name" {
  description = "Name of the IAM role associated with the instance profile"
  type        = string
  default     = "aws-ref-instance-role"
}

variable "instance_profile_instance_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
  default     = "aws-ref-instance-role"
}

variable "instance_profile_managed_policy_arns" {
  description = "List of ARNs of managed policies to attach to the role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy",
  ]
}

variable "instance_profile_custom_policy_arns" {
  description = "List of ARNs of custom policies(created outside of this project) to attach to the role"
  type        = list(string)
  default = [
    "arn:aws:iam::391178969547:policy/AllowFromJapan",
    "arn:aws:iam::391178969547:policy/AllowFromJapanAndGlobalServices",
  ]
}

variable "instance_profile_role_path" {
  description = "The path for the IAM role"
  type        = string
  default     = "/"
}

######################## AutoScaling Group  ########################
variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
  default     = ""
}

variable "asg_vpc_zone_identifier" {
  description = "List of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Required if `VPC` is not created as part of this project"
  type        = list(string)
  default     = []
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 4
}

variable "asg_wait_for_capacity_timeout" {
  description = "Timeout for waiting for the desired capacity to be reached"
  type        = number
  default     = 0
}

variable "asg_health_check_type" {
  description = "Health check type for the Auto Scaling Group"
  type        = string
  default     = "ELB"
}

variable "asg_health_check_grace_period" {
  description = "Health check grace period for instances in the Auto Scaling Group"
  type        = number
  default     = 300
}

variable "asg_enable_monitoring" {
  description = "Enable monitoring for the Auto Scaling Group"
  type        = bool
  default     = true
}

