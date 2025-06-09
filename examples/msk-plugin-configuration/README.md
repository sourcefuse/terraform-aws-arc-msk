<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.4, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_msk_connect"></a> [msk\_connect](#module\_msk\_connect) | ../.. | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | ENV for the resource | `string` | `"poc"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project. | `string` | `"arc"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_msk_connect_custom_plugin_arn"></a> [msk\_connect\_custom\_plugin\_arn](#output\_msk\_connect\_custom\_plugin\_arn) | ARN of the custom plugin |
| <a name="output_msk_connect_worker_configuration_arn"></a> [msk\_connect\_worker\_configuration\_arn](#output\_msk\_connect\_worker\_configuration\_arn) | ARN of the worker configuration |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
