# cloud-application-on-aws

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
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
| <a name="input_db_engine"></a> [db\_engine](#input\_db\_engine) | The type of DB Engine | `string` | `"mysql"` | no |
| <a name="input_db_identifier"></a> [db\_identifier](#input\_db\_identifier) | The name of the RDS instance | `string` | `"aws-ref-arch-db-1"` | no |
| <a name="input_efs_name"></a> [efs\_name](#input\_efs\_name) | Name of the Elastic File System | `string` | `"aws-ref-arch-efs"` | no |
| <a name="input_general_tags"></a> [general\_tags](#input\_general\_tags) | General tags to apply to resources created | `map(string)` | <pre>{<br>  "Env": "dev",<br>  "Project_name": "aws-ref-architecture",<br>  "Team": "platform-team"<br>}</pre> | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the role | `string` | `"aws-ref-architecture"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | `"aws-ref-arch-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_parameters"></a> [db\_parameters](#output\_db\_parameters) | List of RDS Parameters |
| <a name="output_efs_parameters"></a> [efs\_parameters](#output\_efs\_parameters) | List of EFS Parameters |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
