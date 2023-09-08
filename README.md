# cloud-application-on-aws

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm_route53"></a> [acm\_route53](#module\_acm\_route53) | shamimice03/acm-route53/aws | n/a |
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | n/a |
| <a name="module_alb_route53_record_1"></a> [alb\_route53\_record\_1](#module\_alb\_route53\_record\_1) | ./modules/alb-route53 | n/a |
| <a name="module_alb_route53_record_2"></a> [alb\_route53\_record\_2](#module\_alb\_route53\_record\_2) | ./modules/alb-route53 | n/a |
| <a name="module_alb_sg"></a> [alb\_sg](#module\_alb\_sg) | terraform-aws-modules/security-group/aws | n/a |
| <a name="module_asg"></a> [asg](#module\_asg) | terraform-aws-modules/autoscaling/aws | n/a |
| <a name="module_custom_iam_policy"></a> [custom\_iam\_policy](#module\_custom\_iam\_policy) | terraform-aws-modules/iam/aws//modules/iam-policy | n/a |
| <a name="module_ec2_sg"></a> [ec2\_sg](#module\_ec2\_sg) | terraform-aws-modules/security-group/aws | n/a |
| <a name="module_efs"></a> [efs](#module\_efs) | ./modules/efs | n/a |
| <a name="module_efs_parameters"></a> [efs\_parameters](#module\_efs\_parameters) | shamimice03/ssm-parameter/aws | n/a |
| <a name="module_efs_sg"></a> [efs\_sg](#module\_efs\_sg) | terraform-aws-modules/security-group/aws | n/a |
| <a name="module_instance_profile"></a> [instance\_profile](#module\_instance\_profile) | ./modules/iam-instance-profile | n/a |
| <a name="module_launch_template"></a> [launch\_template](#module\_launch\_template) | ./modules/launch-template | n/a |
| <a name="module_primary_db_parameters"></a> [primary\_db\_parameters](#module\_primary\_db\_parameters) | shamimice03/ssm-parameter/aws | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | shamimice03/rds-blueprint/aws | n/a |
| <a name="module_rds_replica"></a> [rds\_replica](#module\_rds\_replica) | shamimice03/rds-blueprint/aws | n/a |
| <a name="module_rds_sg"></a> [rds\_sg](#module\_rds\_sg) | terraform-aws-modules/security-group/aws | n/a |
| <a name="module_replica_db_parameters"></a> [replica\_db\_parameters](#module\_replica\_db\_parameters) | shamimice03/ssm-parameter/aws | n/a |
| <a name="module_ssh_sg"></a> [ssh\_sg](#module\_ssh\_sg) | terraform-aws-modules/security-group/aws | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | shamimice03/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.amazonlinux2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_allow_record_overwrite"></a> [acm\_allow\_record\_overwrite](#input\_acm\_allow\_record\_overwrite) | Allow record overwrite in DNS validation | `bool` | `true` | no |
| <a name="input_acm_domain_name"></a> [acm\_domain\_name](#input\_acm\_domain\_name) | Domain name for ACM certificate | `string` | `"demo.kubecloud.net"` | no |
| <a name="input_acm_hosted_zone_name"></a> [acm\_hosted\_zone\_name](#input\_acm\_hosted\_zone\_name) | Hosted zone name for DNS validation | `string` | `"kubecloud.net"` | no |
| <a name="input_acm_private_zone"></a> [acm\_private\_zone](#input\_acm\_private\_zone) | Whether the hosted zone is private or not | `bool` | `false` | no |
| <a name="input_acm_ttl"></a> [acm\_ttl](#input\_acm\_ttl) | Time to live (TTL) for DNS records | `number` | `60` | no |
| <a name="input_acm_validation_method"></a> [acm\_validation\_method](#input\_acm\_validation\_method) | Validation method for ACM certificate | `string` | `"DNS"` | no |
| <a name="input_alb_name_prefix"></a> [alb\_name\_prefix](#input\_alb\_name\_prefix) | Prefix for the Application Load Balancer name | `string` | `"awsref"` | no |
| <a name="input_alb_route53_evaluate_target_health"></a> [alb\_route53\_evaluate\_target\_health](#input\_alb\_route53\_evaluate\_target\_health) | Whether to evaluate the target health of the ALB | `bool` | `true` | no |
| <a name="input_alb_route53_private_zone"></a> [alb\_route53\_private\_zone](#input\_alb\_route53\_private\_zone) | Whether the DNS zone is private or not | `bool` | `false` | no |
| <a name="input_alb_route53_record_name_1"></a> [alb\_route53\_record\_name\_1](#input\_alb\_route53\_record\_name\_1) | The DNS record name for the first ALB record | `string` | `"demo.kubecloud.net"` | no |
| <a name="input_alb_route53_record_name_2"></a> [alb\_route53\_record\_name\_2](#input\_alb\_route53\_record\_name\_2) | The DNS record name for the second ALB record | `string` | `"www.demo.kubecloud.net"` | no |
| <a name="input_alb_route53_record_type"></a> [alb\_route53\_record\_type](#input\_alb\_route53\_record\_type) | The DNS record type for ALB records | `string` | `"A"` | no |
| <a name="input_alb_route53_zone_name"></a> [alb\_route53\_zone\_name](#input\_alb\_route53\_zone\_name) | The DNS zone name | `string` | `"kubecloud.net."` | no |
| <a name="input_alb_security_groups"></a> [alb\_security\_groups](#input\_alb\_security\_groups) | List of security group IDs for the Application Load Balancer (ALB) | `list(string)` | `[]` | no |
| <a name="input_alb_sg_name"></a> [alb\_sg\_name](#input\_alb\_sg\_name) | Name of the ALB security group | `string` | `"aws-ref-alb-sg"` | no |
| <a name="input_alb_subnets"></a> [alb\_subnets](#input\_alb\_subnets) | List of subnet IDs for the Application Load Balancer (ALB) | `list(string)` | `[]` | no |
| <a name="input_alb_target_group_name_prefix"></a> [alb\_target\_group\_name\_prefix](#input\_alb\_target\_group\_name\_prefix) | Prefix for the ALB target group name | `string` | `"ref-tg"` | no |
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Allocated storage for the RDS instance (in GB) | `string` | `"20"` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Apply changes immediately or during the next maintenance window | `bool` | `true` | no |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | Desired capacity of the Auto Scaling Group | `number` | `2` | no |
| <a name="input_asg_enable_monitoring"></a> [asg\_enable\_monitoring](#input\_asg\_enable\_monitoring) | Enable monitoring for the Auto Scaling Group | `bool` | `true` | no |
| <a name="input_asg_health_check_grace_period"></a> [asg\_health\_check\_grace\_period](#input\_asg\_health\_check\_grace\_period) | Health check grace period for instances in the Auto Scaling Group | `number` | `300` | no |
| <a name="input_asg_health_check_type"></a> [asg\_health\_check\_type](#input\_asg\_health\_check\_type) | Health check type for the Auto Scaling Group | `string` | `"ELB"` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | Maximum size of the Auto Scaling Group | `number` | `4` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | Minimum size of the Auto Scaling Group | `number` | `2` | no |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | Name of the Auto Scaling Group | `string` | `""` | no |
| <a name="input_asg_vpc_zone_identifier"></a> [asg\_vpc\_zone\_identifier](#input\_asg\_vpc\_zone\_identifier) | List of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Required if `VPC` is not created as part of this project | `list(string)` | `[]` | no |
| <a name="input_asg_wait_for_capacity_timeout"></a> [asg\_wait\_for\_capacity\_timeout](#input\_asg\_wait\_for\_capacity\_timeout) | Timeout for waiting for the desired capacity to be reached | `number` | `0` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | Availability Zones for subnets | `list(string)` | <pre>[<br>  "ap-northeast-1a",<br>  "ap-northeast-1c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Backup retention period (in days) for the RDS instance | `number` | `7` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Preferred backup window for the RDS instance | `string` | `"03:00-05:00"` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR block for the VPC | `string` | `"10.3.0.0/16"` | no |
| <a name="input_create_alb_sg"></a> [create\_alb\_sg](#input\_create\_alb\_sg) | Whether to create the Application Load Balancer (ALB) security group. | `bool` | `true` | no |
| <a name="input_create_custom_policy"></a> [create\_custom\_policy](#input\_create\_custom\_policy) | Whether to create custom policy | `bool` | `true` | no |
| <a name="input_create_db_subnet_group"></a> [create\_db\_subnet\_group](#input\_create\_db\_subnet\_group) | Create a new DB subnet group | `bool` | `true` | no |
| <a name="input_create_ec2_sg"></a> [create\_ec2\_sg](#input\_create\_ec2\_sg) | Whether to create the EC2 instance security group. | `bool` | `true` | no |
| <a name="input_create_efs_sg"></a> [create\_efs\_sg](#input\_create\_efs\_sg) | Whether to create the Elastic File System (EFS) security group. | `bool` | `true` | no |
| <a name="input_create_rds_sg"></a> [create\_rds\_sg](#input\_create\_rds\_sg) | Whether to create the RDS security group. | `bool` | `true` | no |
| <a name="input_create_ssh_sg"></a> [create\_ssh\_sg](#input\_create\_ssh\_sg) | Whether to create the SSH security group. | `bool` | `true` | no |
| <a name="input_custom_iam_policy_description"></a> [custom\_iam\_policy\_description](#input\_custom\_iam\_policy\_description) | Description for the IAM policy. Required if `create_custom_policy` set to `true` | `string` | `"List all s3 buckets"` | no |
| <a name="input_custom_iam_policy_json"></a> [custom\_iam\_policy\_json](#input\_custom\_iam\_policy\_json) | JSON policy document. Required if `create_custom_policy` set to `true` | `string` | `"{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": \"s3:ListAllMyBuckets\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"` | no |
| <a name="input_custom_iam_policy_name_prefix"></a> [custom\_iam\_policy\_name\_prefix](#input\_custom\_iam\_policy\_name\_prefix) | Prefix for the IAM policy name. Required if `create_custom_policy` set to `true` | `string` | `"ListAllS3Buckets"` | no |
| <a name="input_custom_iam_policy_path"></a> [custom\_iam\_policy\_path](#input\_custom\_iam\_policy\_path) | The path for the IAM policy. Required if `create_custom_policy` set to `true` | `string` | `"/"` | no |
| <a name="input_database_port"></a> [database\_port](#input\_database\_port) | Port for the RDS instance | `number` | `3306` | no |
| <a name="input_db_identifier"></a> [db\_identifier](#input\_db\_identifier) | The name of the RDS instance | `string` | `"aws-ref-arch-db"` | no |
| <a name="input_db_master_username"></a> [db\_master\_username](#input\_db\_master\_username) | Master username for the RDS instance | `string` | `"admin"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Name of the initial database | `string` | `"userlist"` | no |
| <a name="input_db_security_groups"></a> [db\_security\_groups](#input\_db\_security\_groups) | List of security group IDs for the RDS instance | `list(string)` | `[]` | no |
| <a name="input_db_subnet_cidr"></a> [db\_subnet\_cidr](#input\_db\_subnet\_cidr) | CIDR blocks for database subnets | `list(string)` | <pre>[<br>  "10.3.64.0/20",<br>  "10.3.80.0/20"<br>]</pre> | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name for the DB subnet group | `string` | `"aws-ref-arch-db-subnet"` | no |
| <a name="input_db_subnets"></a> [db\_subnets](#input\_db\_subnets) | List of DB subnets for the RDS instance | `list(string)` | `[]` | no |
| <a name="input_delete_automated_backups"></a> [delete\_automated\_backups](#input\_delete\_automated\_backups) | Delete automated backups when the RDS instance is deleted | `bool` | `true` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Enable or disable deletion protection for the RDS instance | `bool` | `false` | no |
| <a name="input_ec2_sg_name"></a> [ec2\_sg\_name](#input\_ec2\_sg\_name) | Name of the ec2 security group | `string` | `"aws-ref-ec2-sg"` | no |
| <a name="input_efs_encrypted"></a> [efs\_encrypted](#input\_efs\_encrypted) | Whether to enable encryption for the EFS file system | `bool` | `true` | no |
| <a name="input_efs_mount_target_security_group_ids"></a> [efs\_mount\_target\_security\_group\_ids](#input\_efs\_mount\_target\_security\_group\_ids) | List of security group IDs for EFS mount targets | `list(string)` | `[]` | no |
| <a name="input_efs_mount_target_subnet_ids"></a> [efs\_mount\_target\_subnet\_ids](#input\_efs\_mount\_target\_subnet\_ids) | List of subnet IDs for EFS mount targets | `list(string)` | `[]` | no |
| <a name="input_efs_name"></a> [efs\_name](#input\_efs\_name) | Name of the Elastic File System | `string` | `"aws-ref-arch-efs"` | no |
| <a name="input_efs_performance_mode"></a> [efs\_performance\_mode](#input\_efs\_performance\_mode) | The performance mode for the EFS file system (e.g., 'generalPurpose' or 'maxIO') | `string` | `"generalPurpose"` | no |
| <a name="input_efs_sg_name"></a> [efs\_sg\_name](#input\_efs\_sg\_name) | Name of the EFS security group | `string` | `"aws-ref-efs-sg"` | no |
| <a name="input_efs_throughput_mode"></a> [efs\_throughput\_mode](#input\_efs\_throughput\_mode) | The throughput mode for the EFS file system (e.g., 'bursting' or 'provisioned') | `string` | `"bursting"` | no |
| <a name="input_efs_transition_to_ia"></a> [efs\_transition\_to\_ia](#input\_efs\_transition\_to\_ia) | The lifecycle policy transition for files to Infrequent Access (IA) storage | `string` | `"AFTER_30_DAYS"` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames for the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS resolution for the VPC | `bool` | `true` | no |
| <a name="input_enable_single_nat_gateway"></a> [enable\_single\_nat\_gateway](#input\_enable\_single\_nat\_gateway) | Enable a single NAT gateway for all private subnets | `bool` | `false` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of CloudWatch logs to export for the RDS instance | `list(string)` | <pre>[<br>  "audit",<br>  "error"<br>]</pre> | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Database engine type | `string` | `"mysql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Database engine version | `string` | `"8.0"` | no |
| <a name="input_general_tags"></a> [general\_tags](#input\_general\_tags) | General tags to apply to resources created | `map(string)` | <pre>{<br>  "Env": "dev",<br>  "Project_name": "aws-ref-architecture",<br>  "Team": "platform-team"<br>}</pre> | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Enable IAM database authentication | `bool` | `false` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | RDS instance class | `string` | `"db.t3.micro"` | no |
| <a name="input_instance_profile_create_instance_profile"></a> [instance\_profile\_create\_instance\_profile](#input\_instance\_profile\_create\_instance\_profile) | Whether to create an instance profile | `bool` | `true` | no |
| <a name="input_instance_profile_custom_policy_arns"></a> [instance\_profile\_custom\_policy\_arns](#input\_instance\_profile\_custom\_policy\_arns) | List of ARNs of custom policies(created outside of this project) to attach to the role | `list(string)` | <pre>[<br>  "arn:aws:iam::391178969547:policy/AllowFromJapan",<br>  "arn:aws:iam::391178969547:policy/AllowFromJapanAndGlobalServices"<br>]</pre> | no |
| <a name="input_instance_profile_instance_profile_name"></a> [instance\_profile\_instance\_profile\_name](#input\_instance\_profile\_instance\_profile\_name) | Name of the IAM instance profile | `string` | `"aws-ref-instance-role"` | no |
| <a name="input_instance_profile_managed_policy_arns"></a> [instance\_profile\_managed\_policy\_arns](#input\_instance\_profile\_managed\_policy\_arns) | List of ARNs of managed policies to attach to the role | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",<br>  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",<br>  "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess",<br>  "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"<br>]</pre> | no |
| <a name="input_instance_profile_role_name"></a> [instance\_profile\_role\_name](#input\_instance\_profile\_role\_name) | Name of the IAM role associated with the instance profile | `string` | `"aws-ref-instance-role"` | no |
| <a name="input_instance_profile_role_path"></a> [instance\_profile\_role\_path](#input\_instance\_profile\_role\_path) | The path for the IAM role | `string` | `"/"` | no |
| <a name="input_launch_template_delete_on_termination"></a> [launch\_template\_delete\_on\_termination](#input\_launch\_template\_delete\_on\_termination) | Whether the root volume should be deleted on instance termination | `bool` | `true` | no |
| <a name="input_launch_template_device_name"></a> [launch\_template\_device\_name](#input\_launch\_template\_device\_name) | The device name for the root volume | `string` | `"/dev/sda1"` | no |
| <a name="input_launch_template_enable_monitoring"></a> [launch\_template\_enable\_monitoring](#input\_launch\_template\_enable\_monitoring) | Whether instance monitoring should be enabled | `bool` | `false` | no |
| <a name="input_launch_template_image_id"></a> [launch\_template\_image\_id](#input\_launch\_template\_image\_id) | The AMI from which to launch the instance. Default will be `Amazonlinux2` | `string` | `""` | no |
| <a name="input_launch_template_instance_type"></a> [launch\_template\_instance\_type](#input\_launch\_template\_instance\_type) | The EC2 instance type for instances launched from the template | `string` | `"t2.micro"` | no |
| <a name="input_launch_template_key_name"></a> [launch\_template\_key\_name](#input\_launch\_template\_key\_name) | The name of the SSH key pair to associate with instances launched from the template | `string` | `"ec2-access"` | no |
| <a name="input_launch_template_name_prefix"></a> [launch\_template\_name\_prefix](#input\_launch\_template\_name\_prefix) | Creates a unique name beginning with the specified prefix | `string` | `"aws-ref"` | no |
| <a name="input_launch_template_resource_type"></a> [launch\_template\_resource\_type](#input\_launch\_template\_resource\_type) | The type of resource to tag | `string` | `"instance"` | no |
| <a name="input_launch_template_sg_ids"></a> [launch\_template\_sg\_ids](#input\_launch\_template\_sg\_ids) | List of security group IDs for the launch template | `list(string)` | `[]` | no |
| <a name="input_launch_template_update_default_version"></a> [launch\_template\_update\_default\_version](#input\_launch\_template\_update\_default\_version) | Flag to update the default version of the launch template | `bool` | `true` | no |
| <a name="input_launch_template_userdata_file_path"></a> [launch\_template\_userdata\_file\_path](#input\_launch\_template\_userdata\_file\_path) | Path to the user data script file | `string` | `"userdata.sh"` | no |
| <a name="input_launch_template_volume_size"></a> [launch\_template\_volume\_size](#input\_launch\_template\_volume\_size) | The size of the root volume for instances launched from the template (in GiB) | `number` | `20` | no |
| <a name="input_launch_template_volume_type"></a> [launch\_template\_volume\_type](#input\_launch\_template\_volume\_type) | The type of volume for the root volume (e.g., 'gp2') | `string` | `"gp2"` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Type of the Load Balancer | `string` | `"application"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window for the RDS instance | `string` | `"Sat:05:00-Sat:07:00"` | no |
| <a name="input_master_db_availability_zone"></a> [master\_db\_availability\_zone](#input\_master\_db\_availability\_zone) | Availability zone for the RDS instance | `string` | `"ap-northeast-1a"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Maximum allocated storage for the RDS instance (in GB) | `string` | `"20"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Enable multi-AZ deployment for the RDS instance | `bool` | `false` | no |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | CIDR blocks for private subnets | `list(string)` | <pre>[<br>  "10.3.32.0/20",<br>  "10.3.48.0/20"<br>]</pre> | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"aws-ref-architecture"` | no |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | CIDR blocks for public subnets | `list(string)` | <pre>[<br>  "10.3.0.0/20",<br>  "10.3.16.0/20"<br>]</pre> | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Make the RDS instance publicly accessible | `bool` | `false` | no |
| <a name="input_rds_sg_name"></a> [rds\_sg\_name](#input\_rds\_sg\_name) | Name of the RDS security group | `string` | `"aws-ref-rds-sg"` | no |
| <a name="input_replica_apply_immediately"></a> [replica\_apply\_immediately](#input\_replica\_apply\_immediately) | Apply changes immediately or during the next maintenance window for the replica | `bool` | `null` | no |
| <a name="input_replica_backup_retention_period"></a> [replica\_backup\_retention\_period](#input\_replica\_backup\_retention\_period) | Backup retention period (in days) for the RDS replica instance | `number` | `null` | no |
| <a name="input_replica_backup_window"></a> [replica\_backup\_window](#input\_replica\_backup\_window) | Preferred backup window for the RDS replica instance | `string` | `""` | no |
| <a name="input_replica_database_port"></a> [replica\_database\_port](#input\_replica\_database\_port) | Port for the RDS replica instance | `number` | `null` | no |
| <a name="input_replica_db_availability_zone"></a> [replica\_db\_availability\_zone](#input\_replica\_db\_availability\_zone) | Availability zone for the RDS replica instance | `string` | `"ap-northeast-1c"` | no |
| <a name="input_replica_db_identifier"></a> [replica\_db\_identifier](#input\_replica\_db\_identifier) | Identifier for the RDS replica instance | `string` | `""` | no |
| <a name="input_replica_delete_automated_backups"></a> [replica\_delete\_automated\_backups](#input\_replica\_delete\_automated\_backups) | Delete automated backups when the RDS replica instance is deleted | `bool` | `null` | no |
| <a name="input_replica_deletion_protection"></a> [replica\_deletion\_protection](#input\_replica\_deletion\_protection) | Enable or disable deletion protection for the RDS replica instance | `bool` | `null` | no |
| <a name="input_replica_enabled_cloudwatch_logs_exports"></a> [replica\_enabled\_cloudwatch\_logs\_exports](#input\_replica\_enabled\_cloudwatch\_logs\_exports) | List of CloudWatch logs to export for the RDS replica instance | `list(string)` | `[]` | no |
| <a name="input_replica_engine"></a> [replica\_engine](#input\_replica\_engine) | Database engine type for the RDS replica instance | `string` | `""` | no |
| <a name="input_replica_engine_version"></a> [replica\_engine\_version](#input\_replica\_engine\_version) | Database engine version for the RDS replica instance | `string` | `""` | no |
| <a name="input_replica_iam_database_authentication_enabled"></a> [replica\_iam\_database\_authentication\_enabled](#input\_replica\_iam\_database\_authentication\_enabled) | Enable IAM database authentication | `bool` | `null` | no |
| <a name="input_replica_instance_class"></a> [replica\_instance\_class](#input\_replica\_instance\_class) | RDS instance class for the replica | `string` | `""` | no |
| <a name="input_replica_maintenance_window"></a> [replica\_maintenance\_window](#input\_replica\_maintenance\_window) | Maintenance window for the RDS replica instance | `string` | `""` | no |
| <a name="input_replica_max_allocated_storage"></a> [replica\_max\_allocated\_storage](#input\_replica\_max\_allocated\_storage) | Maximum allocated storage for the RDS replica instance (in GB) | `string` | `""` | no |
| <a name="input_replica_multi_az"></a> [replica\_multi\_az](#input\_replica\_multi\_az) | Enable multi-AZ deployment for the RDS replica instance | `bool` | `null` | no |
| <a name="input_replica_publicly_accessible"></a> [replica\_publicly\_accessible](#input\_replica\_publicly\_accessible) | Make the RDS replica instance publicly accessible | `bool` | `null` | no |
| <a name="input_replica_skip_final_snapshot"></a> [replica\_skip\_final\_snapshot](#input\_replica\_skip\_final\_snapshot) | Skip the final DB snapshot when the RDS replica instance is deleted | `bool` | `null` | no |
| <a name="input_replica_storage_type"></a> [replica\_storage\_type](#input\_replica\_storage\_type) | Storage type for the RDS replica instance | `string` | `""` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Skip the final DB snapshot when the RDS instance is deleted | `bool` | `true` | no |
| <a name="input_ssh_sg_name"></a> [ssh\_sg\_name](#input\_ssh\_sg\_name) | Name of the SSH security group | `string` | `"aws-ref-ssh-sg"` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Storage type for the RDS instance | `string` | `"gp2"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | `"aws-ref-arch-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_parameters"></a> [efs\_parameters](#output\_efs\_parameters) | List of EFS Parameters |
| <a name="output_primary_db_parameters"></a> [primary\_db\_parameters](#output\_primary\_db\_parameters) | List of Primary DB Parameters |
| <a name="output_replica_db_parameters"></a> [replica\_db\_parameters](#output\_replica\_db\_parameters) | List of Primary DB Parameters |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
