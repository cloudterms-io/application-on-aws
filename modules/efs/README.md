<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.16.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs_mount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_efs_encrypted"></a> [efs\_encrypted](#input\_efs\_encrypted) | Whether EFS should be encrypted | `bool` | `true` | no |
| <a name="input_efs_mount_target_security_group_ids"></a> [efs\_mount\_target\_security\_group\_ids](#input\_efs\_mount\_target\_security\_group\_ids) | IDs of the mount targets security group for EFS | `list(string)` | `[]` | no |
| <a name="input_efs_mount_target_subnet_ids"></a> [efs\_mount\_target\_subnet\_ids](#input\_efs\_mount\_target\_subnet\_ids) | List of mount targets subnet IDs | `list(string)` | `[]` | no |
| <a name="input_efs_performance_mode"></a> [efs\_performance\_mode](#input\_efs\_performance\_mode) | EFS performance mode (e.g., 'generalPurpose', 'maxIO') | `string` | `"generalPurpose"` | no |
| <a name="input_efs_tags"></a> [efs\_tags](#input\_efs\_tags) | Tags for the EFS file system | `map(string)` | `{}` | no |
| <a name="input_efs_throughput_mode"></a> [efs\_throughput\_mode](#input\_efs\_throughput\_mode) | EFS throughput mode (e.g., 'provisioned', 'bursting','elastic) | `string` | `"bursting"` | no |
| <a name="input_efs_transition_to_ia"></a> [efs\_transition\_to\_ia](#input\_efs\_transition\_to\_ia) | Indicates how long it takes to transition files to the IA storage class. Valid values: AFTER\_1\_DAY, AFTER\_7\_DAYS, AFTER\_14\_DAYS, AFTER\_30\_DAYS, AFTER\_60\_DAYS, or AFTER\_90\_DAYS | `string` | `"AFTER_30_DAYS"` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name used as reference when creating the Elastic File System to ensure idempotent file system creation | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the EFS file system |
| <a name="output_mount_target_ids"></a> [mount\_target\_ids](#output\_mount\_target\_ids) | List of IDs of EFS mount targets |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
