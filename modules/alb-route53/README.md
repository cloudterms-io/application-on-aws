<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.15.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_record"></a> [create\_record](#input\_create\_record) | Whether to create DNS record | `bool` | `true` | no |
| <a name="input_evaluate_target_health"></a> [evaluate\_target\_health](#input\_evaluate\_target\_health) | Whether to evaluate the target health of the alias record | `bool` | `true` | no |
| <a name="input_lb_dns_name"></a> [lb\_dns\_name](#input\_lb\_dns\_name) | The DNS name to which the record should alias | `string` | `""` | no |
| <a name="input_lb_zone_id"></a> [lb\_zone\_id](#input\_lb\_zone\_id) | The Route 53 zone ID of the alias target | `string` | `""` | no |
| <a name="input_private_zone"></a> [private\_zone](#input\_private\_zone) | Whether the Route 53 zone is private or not | `bool` | `false` | no |
| <a name="input_record_name"></a> [record\_name](#input\_record\_name) | The name of the Route 53 record | `string` | `""` | no |
| <a name="input_record_type"></a> [record\_type](#input\_record\_type) | The type of the Route 53 record (e.g., A, CNAME, etc.) | `string` | `""` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | The name of the Route 53 zone | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_record_id"></a> [record\_id](#output\_record\_id) | The ID of the Route 53 record |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
