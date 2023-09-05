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
| <a name="module_asg"></a> [asg](#module\_asg) | terraform-aws-modules/autoscaling/aws | n/a |
| <a name="module_db_parameters"></a> [db\_parameters](#module\_db\_parameters) | shamimice03/ssm-parameter/aws | n/a |
| <a name="module_efs"></a> [efs](#module\_efs) | ./modules/efs | n/a |
| <a name="module_efs_parameters"></a> [efs\_parameters](#module\_efs\_parameters) | shamimice03/ssm-parameter/aws | n/a |
| <a name="module_instance_profile"></a> [instance\_profile](#module\_instance\_profile) | ./modules/iam-instance-profile | n/a |
| <a name="module_launch_template"></a> [launch\_template](#module\_launch\_template) | ./modules/launch-template | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | shamimice03/rds-blueprint/aws | n/a |
| <a name="module_rds_replica"></a> [rds\_replica](#module\_rds\_replica) | shamimice03/rds-blueprint/aws | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | shamimice03/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.demo_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.efs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.public_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.amazonlinux2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Allocated storage for the RDS instance (in GB) | `string` | `"20"` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Apply changes immediately or during the next maintenance window | `bool` | `true` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | Availability Zones for subnets | `list(string)` | <pre>[<br>  "ap-northeast-1a",<br>  "ap-northeast-1c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Backup retention period (in days) for the RDS instance | `number` | `7` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Preferred backup window for the RDS instance | `string` | `"03:00-05:00"` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR block for the VPC | `string` | `"10.3.0.0/16"` | no |
| <a name="input_create_db_subnet_group"></a> [create\_db\_subnet\_group](#input\_create\_db\_subnet\_group) | Create a new DB subnet group | `bool` | `true` | no |
| <a name="input_database_port"></a> [database\_port](#input\_database\_port) | Port for the RDS instance | `number` | `3306` | no |
| <a name="input_db_engine"></a> [db\_engine](#input\_db\_engine) | The type of DB Engine | `string` | `"mysql"` | no |
| <a name="input_db_identifier"></a> [db\_identifier](#input\_db\_identifier) | The name of the RDS instance | `string` | `"aws-ref-arch-db"` | no |
| <a name="input_db_master_username"></a> [db\_master\_username](#input\_db\_master\_username) | Master username for the RDS instance | `string` | `"admin"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Name of the initial database | `string` | `"userlist"` | no |
| <a name="input_db_security_groups"></a> [db\_security\_groups](#input\_db\_security\_groups) | List of security group IDs for the RDS instance | `list(string)` | `[]` | no |
| <a name="input_db_subnet_cidr"></a> [db\_subnet\_cidr](#input\_db\_subnet\_cidr) | CIDR blocks for database subnets | `list(string)` | <pre>[<br>  "10.3.64.0/20",<br>  "10.3.80.0/20"<br>]</pre> | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name for the DB subnet group | `string` | `"aws-ref-arch-db-subnet"` | no |
| <a name="input_db_subnets"></a> [db\_subnets](#input\_db\_subnets) | List of DB subnets for the RDS instance | `list(string)` | `[]` | no |
| <a name="input_delete_automated_backups"></a> [delete\_automated\_backups](#input\_delete\_automated\_backups) | Delete automated backups when the RDS instance is deleted | `bool` | `true` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Enable or disable deletion protection for the RDS instance | `bool` | `false` | no |
| <a name="input_efs_name"></a> [efs\_name](#input\_efs\_name) | Name of the Elastic File System | `string` | `"aws-ref-arch-efs"` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames for the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS resolution for the VPC | `bool` | `true` | no |
| <a name="input_enable_single_nat_gateway"></a> [enable\_single\_nat\_gateway](#input\_enable\_single\_nat\_gateway) | Enable a single NAT gateway for all private subnets | `bool` | `false` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of CloudWatch logs to export for the RDS instance | `list(string)` | <pre>[<br>  "audit",<br>  "error"<br>]</pre> | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Database engine type | `string` | `"mysql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Database engine version | `string` | `"8.0"` | no |
| <a name="input_general_tags"></a> [general\_tags](#input\_general\_tags) | General tags to apply to resources created | `map(string)` | <pre>{<br>  "Env": "dev",<br>  "Project_name": "aws-ref-architecture",<br>  "Team": "platform-team"<br>}</pre> | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Enable IAM database authentication | `bool` | `false` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | RDS instance class | `string` | `"db.t3.micro"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window for the RDS instance | `string` | `"Sat:05:00-Sat:07:00"` | no |
| <a name="input_master_db_availability_zone"></a> [master\_db\_availability\_zone](#input\_master\_db\_availability\_zone) | Availability zone for the RDS instance | `string` | `"ap-northeast-1a"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Maximum allocated storage for the RDS instance (in GB) | `string` | `"20"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Enable multi-AZ deployment for the RDS instance | `bool` | `false` | no |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | CIDR blocks for private subnets | `list(string)` | <pre>[<br>  "10.3.32.0/20",<br>  "10.3.48.0/20"<br>]</pre> | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the role | `string` | `"aws-ref-architecture"` | no |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | CIDR blocks for public subnets | `list(string)` | <pre>[<br>  "10.3.0.0/20",<br>  "10.3.16.0/20"<br>]</pre> | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Make the RDS instance publicly accessible | `bool` | `false` | no |
| <a name="input_replica_allocated_storage"></a> [replica\_allocated\_storage](#input\_replica\_allocated\_storage) | Allocated storage for the RDS replica instance (in GB) | `string` | `""` | no |
| <a name="input_replica_apply_immediately"></a> [replica\_apply\_immediately](#input\_replica\_apply\_immediately) | Apply changes immediately or during the next maintenance window for the replica | `bool` | n/a | yes |
| <a name="input_replica_backup_retention_period"></a> [replica\_backup\_retention\_period](#input\_replica\_backup\_retention\_period) | Backup retention period (in days) for the RDS replica instance | `number` | `null` | no |
| <a name="input_replica_backup_window"></a> [replica\_backup\_window](#input\_replica\_backup\_window) | Preferred backup window for the RDS replica instance | `string` | `""` | no |
| <a name="input_replica_database_port"></a> [replica\_database\_port](#input\_replica\_database\_port) | Port for the RDS replica instance | `number` | `null` | no |
| <a name="input_replica_db_availability_zone"></a> [replica\_db\_availability\_zone](#input\_replica\_db\_availability\_zone) | Availability zone for the RDS replica instance | `string` | `""` | no |
| <a name="input_replica_db_identifier"></a> [replica\_db\_identifier](#input\_replica\_db\_identifier) | Identifier for the RDS replica instance | `string` | `""` | no |
| <a name="input_replica_db_security_groups"></a> [replica\_db\_security\_groups](#input\_replica\_db\_security\_groups) | List of security group IDs for the RDS replica instance | `list(string)` | `[]` | no |
| <a name="input_replica_delete_automated_backups"></a> [replica\_delete\_automated\_backups](#input\_replica\_delete\_automated\_backups) | Delete automated backups when the RDS replica instance is deleted | `bool` | n/a | yes |
| <a name="input_replica_deletion_protection"></a> [replica\_deletion\_protection](#input\_replica\_deletion\_protection) | Enable or disable deletion protection for the RDS replica instance | `bool` | n/a | yes |
| <a name="input_replica_enabled_cloudwatch_logs_exports"></a> [replica\_enabled\_cloudwatch\_logs\_exports](#input\_replica\_enabled\_cloudwatch\_logs\_exports) | List of CloudWatch logs to export for the RDS replica instance | `list(string)` | `[]` | no |
| <a name="input_replica_engine"></a> [replica\_engine](#input\_replica\_engine) | Database engine type for the RDS replica instance | `string` | `""` | no |
| <a name="input_replica_engine_version"></a> [replica\_engine\_version](#input\_replica\_engine\_version) | Database engine version for the RDS replica instance | `string` | `""` | no |
| <a name="input_replica_instance_class"></a> [replica\_instance\_class](#input\_replica\_instance\_class) | RDS instance class for the replica | `string` | `""` | no |
| <a name="input_replica_maintenance_window"></a> [replica\_maintenance\_window](#input\_replica\_maintenance\_window) | Maintenance window for the RDS replica instance | `string` | `""` | no |
| <a name="input_replica_max_allocated_storage"></a> [replica\_max\_allocated\_storage](#input\_replica\_max\_allocated\_storage) | Maximum allocated storage for the RDS replica instance (in GB) | `string` | `""` | no |
| <a name="input_replica_multi_az"></a> [replica\_multi\_az](#input\_replica\_multi\_az) | Enable multi-AZ deployment for the RDS replica instance | `bool` | n/a | yes |
| <a name="input_replica_publicly_accessible"></a> [replica\_publicly\_accessible](#input\_replica\_publicly\_accessible) | Make the RDS replica instance publicly accessible | `bool` | n/a | yes |
| <a name="input_replica_skip_final_snapshot"></a> [replica\_skip\_final\_snapshot](#input\_replica\_skip\_final\_snapshot) | Skip the final DB snapshot when the RDS replica instance is deleted | `bool` | n/a | yes |
| <a name="input_replica_storage_type"></a> [replica\_storage\_type](#input\_replica\_storage\_type) | Storage type for the RDS replica instance | `string` | `""` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Skip the final DB snapshot when the RDS instance is deleted | `bool` | `true` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Storage type for the RDS instance | `string` | `"gp2"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | `"aws-ref-arch-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_parameters"></a> [db\_parameters](#output\_db\_parameters) | List of RDS Parameters |
| <a name="output_efs_parameters"></a> [efs\_parameters](#output\_efs\_parameters) | List of EFS Parameters |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
