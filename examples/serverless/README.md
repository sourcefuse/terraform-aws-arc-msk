<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.4, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.98.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_msk_serverless"></a> [msk\_serverless](#module\_msk\_serverless) | ../.. | n/a |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | sourcefuse/arc-security-group/aws | 0.0.2 |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

| Name | Type |
|------|------|
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, i.e. dev, stage, prod | `string` | `"poc"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the project, i.e. arc | `string` | `"arc"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_serverless_bootstrap_brokers_sasl_iam"></a> [serverless\_bootstrap\_brokers\_sasl\_iam](#output\_serverless\_bootstrap\_brokers\_sasl\_iam) | Bootstrap broker endpoints with SASL IAM |
| <a name="output_serverless_cluster_uuid"></a> [serverless\_cluster\_uuid](#output\_serverless\_cluster\_uuid) | UUID of the MSK serverless cluster |
| <a name="output_serverless_msk_cluster_arn"></a> [serverless\_msk\_cluster\_arn](#output\_serverless\_msk\_cluster\_arn) | ARN of the MSK serverless cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
