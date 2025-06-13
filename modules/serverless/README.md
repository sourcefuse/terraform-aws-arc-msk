<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.99.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_msk_cluster_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster_policy) | resource |
| [aws_msk_serverless_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_serverless_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the MSK cluster | `string` | n/a | yes |
| <a name="input_create_cluster_policy"></a> [create\_cluster\_policy](#input\_create\_cluster\_policy) | Whether to create an MSK cluster policy | `bool` | `false` | no |
| <a name="input_policy_statements"></a> [policy\_statements](#input\_policy\_statements) | List of policy statements for MSK cluster access | <pre>list(object({<br/>    sid       = string<br/>    effect    = string<br/>    actions   = list(string)<br/>    principal = map(any) # Allow "AWS", "Service", etc.<br/>    resources = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_sasl_iam_enabled"></a> [sasl\_iam\_enabled](#input\_sasl\_iam\_enabled) | Enable IAM-based SASL authentication | `bool` | `true` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs (up to five) | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs in at least two different Availability Zones | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the MSK resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_serverless_bootstrap_brokers_sasl_iam"></a> [serverless\_bootstrap\_brokers\_sasl\_iam](#output\_serverless\_bootstrap\_brokers\_sasl\_iam) | Bootstrap broker endpoints with SASL IAM |
| <a name="output_serverless_cluster_uuid"></a> [serverless\_cluster\_uuid](#output\_serverless\_cluster\_uuid) | UUID of the MSK cluster |
| <a name="output_serverless_msk_cluster_arn"></a> [serverless\_msk\_cluster\_arn](#output\_serverless\_msk\_cluster\_arn) | ARN of the MSK serverless cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
