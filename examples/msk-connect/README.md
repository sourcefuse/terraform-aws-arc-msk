<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.4, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.99.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_msk"></a> [msk](#module\_msk) | ../.. | n/a |
| <a name="module_msk_connect"></a> [msk\_connect](#module\_msk\_connect) | ../.. | n/a |
| <a name="module_msk_s3_sink"></a> [msk\_s3\_sink](#module\_msk\_s3\_sink) | ../.. | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | sourcefuse/arc-s3/aws | v0.0.4 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | sourcefuse/arc-security-group/aws | 0.0.2 |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.msk_source_destination_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_s3_object.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_ssm_parameter.db_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.db_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.db_username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name, e.g. 'prod', 'staging', 'dev', 'test' | `string` | `"poc"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'arc' | `string` | `"arc"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_zip_files"></a> [zip\_files](#input\_zip\_files) | n/a | `list(string)` | <pre>[<br/>  "confluentinc-kafka-connect-s3-10.6.6.zip",<br/>  "confluentinc-kafka-connect-jdbc-10.6.6.zip"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap_brokers_sasl_iam"></a> [bootstrap\_brokers\_sasl\_iam](#output\_bootstrap\_brokers\_sasl\_iam) | Bootstrap brokers for plaintext connections |
| <a name="output_msk_cluster_arn"></a> [msk\_cluster\_arn](#output\_msk\_cluster\_arn) | ARN of the MSK cluster |
| <a name="output_msk_connect_connector_arn"></a> [msk\_connect\_connector\_arn](#output\_msk\_connect\_connector\_arn) | ARN of the MSK Connect connector |
| <a name="output_msk_connect_custom_plugin_arn"></a> [msk\_connect\_custom\_plugin\_arn](#output\_msk\_connect\_custom\_plugin\_arn) | ARN of the custom plugin |
| <a name="output_msk_connect_service_execution_role_arn"></a> [msk\_connect\_service\_execution\_role\_arn](#output\_msk\_connect\_service\_execution\_role\_arn) | ARN of the MSK Connector IAM Role |
| <a name="output_msk_connect_worker_configuration_arn"></a> [msk\_connect\_worker\_configuration\_arn](#output\_msk\_connect\_worker\_configuration\_arn) | ARN of the worker configuration |
| <a name="output_zookeeper_connect_string"></a> [zookeeper\_connect\_string](#output\_zookeeper\_connect\_string) | Zookeeper connection string |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
