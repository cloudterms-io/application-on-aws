<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.instance_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_instance_profile"></a> [create\_instance\_profile](#input\_create\_instance\_profile) | Determine whether to create an instance profile | `bool` | `true` | no |
| <a name="input_custom_policy_arns"></a> [custom\_policy\_arns](#input\_custom\_policy\_arns) | List of custom policy ARNs to attach to the IAM role | `list(string)` | `[]` | no |
| <a name="input_custom_policy_arns_count"></a> [custom\_policy\_arns\_count](#input\_custom\_policy\_arns\_count) | Number of custom policy arns | `number` | `null` | no |
| <a name="input_instance_profile_name"></a> [instance\_profile\_name](#input\_instance\_profile\_name) | Name of the instance profile name | `string` | `""` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | List of managed policy ARNs to attach to the IAM role | `list(string)` | `[]` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the role | `string` | `""` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | Path for the IAM role | `string` | `"/"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_profile_arn"></a> [profile\_arn](#output\_profile\_arn) | ARN of the IAM instance profile |
| <a name="output_profile_name"></a> [profile\_name](#output\_profile\_name) | Name of the IAM instance profile |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of the IAM role |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
