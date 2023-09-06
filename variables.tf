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

######################## VPC ###########################
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
######################## Secuirity Groups ###########################
variable "alb_sg_name" {
  description = "Name of the ALB security group"
  type        = string
  default     = "aws-ref-arch-alb-sg"
}

variable "ec2_sg_name" {
  description = "Name of the ec2 security group"
  type        = string
  default     = "aws-ref-arch-public-sg"
}

variable "efs_sg_name" {
  description = "Name of the EFS security group"
  type        = string
  default     = "aws-ref-arch-efs-sg"
}

variable "rds_sg_name" {
  description = "Name of the RDS security group"
  type        = string
  default     = "aws-ref-arch-rds-sg"
}

variable "ssh_sg_name" {
  description = "Name of the SSH security group"
  type        = string
  default     = "aws-ref-arch-ssh-sg"
}


######################## Primary Database ###########################
variable "db_identifier" {
  description = "The name of the RDS instance"
  type        = string
  default     = "aws-ref-arch-db"
}

variable "db_engine" {
  description = "The type of DB Engine"
  type        = string
  default     = "mysql"
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

######################## Read Replica ###########################
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
  default     = "aws-ref-arch"
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
