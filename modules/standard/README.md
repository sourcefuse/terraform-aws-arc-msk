<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.99.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_kms_alias.msk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.msk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.scram](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_msk_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster) | resource |
| [aws_msk_cluster_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster_policy) | resource |
| [aws_msk_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_configuration) | resource |
| [aws_msk_scram_secret_association.scram](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_scram_secret_association) | resource |
| [aws_msk_vpc_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_vpc_connection) | resource |
| [aws_secretsmanager_secret.scram](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_policy.scram](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_version.scram](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_id.scram_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.scram_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_pet.scram_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_iam_policy_document.scram](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_distribution"></a> [az\_distribution](#input\_az\_distribution) | The distribution of broker nodes across availability zones. Currently the only valid value is DEFAULT | `string` | `"DEFAULT"` | no |
| <a name="input_broker_instance_type"></a> [broker\_instance\_type](#input\_broker\_instance\_type) | Specify the instance type to use for the kafka brokers. e.g. kafka.m5.large | `string` | `"kafka.m5.large"` | no |
| <a name="input_broker_storage"></a> [broker\_storage](#input\_broker\_storage) | Broker EBS storage configuration | <pre>object({<br/>    volume_size                    = number<br/>    provisioned_throughput_enabled = optional(bool, false)<br/>    volume_throughput              = optional(number)<br/>  })</pre> | <pre>{<br/>  "volume_size": 100<br/>}</pre> | no |
| <a name="input_client_authentication"></a> [client\_authentication](#input\_client\_authentication) | Cluster-level client authentication options | <pre>object({<br/>    sasl_scram_enabled             = optional(bool, false)<br/>    sasl_iam_enabled               = optional(bool, false)<br/>    tls_certificate_authority_arns = optional(list(string), [])<br/>    allow_unauthenticated_access   = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_client_broker_encryption"></a> [client\_broker\_encryption](#input\_client\_broker\_encryption) | Encryption setting for client broker communication. Valid values: TLS, TLS\_PLAINTEXT, and PLAINTEXT | `string` | `"TLS"` | no |
| <a name="input_client_subnets"></a> [client\_subnets](#input\_client\_subnets) | A list of subnets to connect to in client VPC. If not provided, private subnets will be fetched using tags | `list(string)` | `[]` | no |
| <a name="input_cluster_configuration"></a> [cluster\_configuration](#input\_cluster\_configuration) | Configuration block for MSK | <pre>object({<br/>    create_configuration      = bool<br/>    configuration_name        = optional(string)<br/>    configuration_description = optional(string)<br/>    server_properties         = optional(string)<br/>    configuration_arn         = optional(string)<br/>    configuration_revision    = optional(number)<br/>  })</pre> | <pre>{<br/>  "create_configuration": false<br/>}</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the MSK cluster | `string` | n/a | yes |
| <a name="input_connectivity_config"></a> [connectivity\_config](#input\_connectivity\_config) | Connectivity settings for public and VPC access | <pre>object({<br/>    public_access_enabled = optional(bool, false)<br/>    public_access_type    = optional(string, "SERVICE_PROVIDED_EIPS") # or "DISABLED"<br/>  })</pre> | `{}` | no |
| <a name="input_create_cluster_policy"></a> [create\_cluster\_policy](#input\_create\_cluster\_policy) | Whether to create the MSK cluster policy | `bool` | `false` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Whether to create a new KMS key | `bool` | `false` | no |
| <a name="input_enhanced_monitoring"></a> [enhanced\_monitoring](#input\_enhanced\_monitoring) | Specify the desired enhanced MSK CloudWatch monitoring level. Valid values: DEFAULT, PER\_BROKER, PER\_TOPIC\_PER\_BROKER, or PER\_TOPIC\_PER\_PARTITION | `string` | `"DEFAULT"` | no |
| <a name="input_in_cluster_encryption"></a> [in\_cluster\_encryption](#input\_in\_cluster\_encryption) | Whether data communication among broker nodes is encrypted. Default is true | `bool` | `true` | no |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | Specify the desired Kafka software version | `string` | `"3.6.0"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS Key ARN | `string` | `""` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | Logging settings | <pre>object({<br/>    cloudwatch_logs_enabled           = optional(bool, false)<br/>    cloudwatch_log_group              = optional(string)<br/>    cloudwatch_logs_retention_in_days = optional(number)<br/>    firehose_logs_enabled             = optional(bool, false)<br/>    firehose_delivery_stream          = optional(string)<br/>    s3_logs_enabled                   = optional(bool, false)<br/>    s3_logs_bucket                    = optional(string)<br/>    s3_logs_prefix                    = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_monitoring_info"></a> [monitoring\_info](#input\_monitoring\_info) | Open monitoring exporter settings | <pre>object({<br/>    jmx_exporter_enabled  = optional(bool, false)<br/>    node_exporter_enabled = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_number_of_broker_nodes"></a> [number\_of\_broker\_nodes](#input\_number\_of\_broker\_nodes) | The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets | `number` | `2` | no |
| <a name="input_policy_statements"></a> [policy\_statements](#input\_policy\_statements) | List of policy statements for the MSK cluster | <pre>list(object({<br/>    sid       = string<br/>    effect    = string<br/>    actions   = list(string)<br/>    principal = map(any)     # Allow "AWS", "Service", etc.<br/>    resources = list(string) # Optional, fallback to cluster_arn<br/>  }))</pre> | `[]` | no |
| <a name="input_scram_password"></a> [scram\_password](#input\_scram\_password) | SCRAM password for MSK authentication (optional, will be generated if not provided) | `string` | `null` | no |
| <a name="input_scram_username"></a> [scram\_username](#input\_scram\_username) | SCRAM username for MSK authentication (optional, will be generated if not provided) | `string` | `null` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group IDs to associate with the MSK cluster | `list(string)` | `[]` | no |
| <a name="input_storage_autoscaling_config"></a> [storage\_autoscaling\_config](#input\_storage\_autoscaling\_config) | Configuration for MSK broker storage autoscaling | <pre>object({<br/>    enabled      = bool<br/>    max_capacity = optional(number, 250)<br/>    role_arn     = optional(string, "")<br/>    target_value = optional(number, 70)<br/>  })</pre> | <pre>{<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_storage_mode"></a> [storage\_mode](#input\_storage\_mode) | Controls storage mode for supported storage tiers. Valid values are: LOCAL or TIERED | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the MSK resources | `map(string)` | `{}` | no |
| <a name="input_vpc_connections"></a> [vpc\_connections](#input\_vpc\_connections) | A map of MSK VPC connection configurations.<br/>Each key is a unique connection name and value is an object with:<br/>- authentication<br/>- client\_subnets<br/>- security\_groups<br/>- target\_cluster\_arn<br/>- vpc\_id<br/>- tags (optional) | <pre>map(object({<br/>    authentication  = string<br/>    client_subnets  = list(string)<br/>    security_groups = list(string)<br/>    vpc_id          = string<br/>  }))</pre> | `{}` | no |
| <a name="input_vpc_connectivity_client_authentication"></a> [vpc\_connectivity\_client\_authentication](#input\_vpc\_connectivity\_client\_authentication) | Client authentication for VPC connectivity | <pre>object({<br/>    sasl_scram_enabled             = optional(bool, false)<br/>    sasl_iam_enabled               = optional(bool, false)<br/>    tls_certificate_authority_arns = optional(list(string), [])<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of the MSK cluster |
| <a name="output_bootstrap_brokers"></a> [bootstrap\_brokers](#output\_bootstrap\_brokers) | A comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster |
| <a name="output_bootstrap_brokers_public_sasl_iam"></a> [bootstrap\_brokers\_public\_sasl\_iam](#output\_bootstrap\_brokers\_public\_sasl\_iam) | A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs for public access |
| <a name="output_bootstrap_brokers_public_sasl_scram"></a> [bootstrap\_brokers\_public\_sasl\_scram](#output\_bootstrap\_brokers\_public\_sasl\_scram) | A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs for public access |
| <a name="output_bootstrap_brokers_public_tls"></a> [bootstrap\_brokers\_public\_tls](#output\_bootstrap\_brokers\_public\_tls) | A comma separated list of one or more DNS names (or IPs) and TLS port pairs for public access |
| <a name="output_bootstrap_brokers_sasl_iam"></a> [bootstrap\_brokers\_sasl\_iam](#output\_bootstrap\_brokers\_sasl\_iam) | A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs kafka brokers suitable to bootstrap connectivity to the kafka cluster |
| <a name="output_bootstrap_brokers_sasl_scram"></a> [bootstrap\_brokers\_sasl\_scram](#output\_bootstrap\_brokers\_sasl\_scram) | A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs kafka brokers suitable to bootstrap connectivity to the kafka cluster |
| <a name="output_bootstrap_brokers_tls"></a> [bootstrap\_brokers\_tls](#output\_bootstrap\_brokers\_tls) | A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to bootstrap connectivity to the kafka cluster |
| <a name="output_bootstrap_brokers_vpc_connectivity_sasl_iam"></a> [bootstrap\_brokers\_vpc\_connectivity\_sasl\_iam](#output\_bootstrap\_brokers\_vpc\_connectivity\_sasl\_iam) | A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs for VPC connectivity |
| <a name="output_bootstrap_brokers_vpc_connectivity_sasl_scram"></a> [bootstrap\_brokers\_vpc\_connectivity\_sasl\_scram](#output\_bootstrap\_brokers\_vpc\_connectivity\_sasl\_scram) | A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs for VPC connectivity |
| <a name="output_bootstrap_brokers_vpc_connectivity_tls"></a> [bootstrap\_brokers\_vpc\_connectivity\_tls](#output\_bootstrap\_brokers\_vpc\_connectivity\_tls) | A comma separated list of one or more DNS names (or IPs) and TLS port pairs for VPC connectivity |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the MSK cluster |
| <a name="output_cluster_uuid"></a> [cluster\_uuid](#output\_cluster\_uuid) | UUID of the MSK cluster, for use in IAM policies |
| <a name="output_configuration_latest_revision"></a> [configuration\_latest\_revision](#output\_configuration\_latest\_revision) | Latest revision of the MSK configuration |
| <a name="output_current_version"></a> [current\_version](#output\_current\_version) | Current version of the MSK Cluster used for updates |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | Alias for the MSK KMS key |
| <a name="output_msk_cluster_policy_id"></a> [msk\_cluster\_policy\_id](#output\_msk\_cluster\_policy\_id) | The ID of the MSK cluster policy |
| <a name="output_storage_mode"></a> [storage\_mode](#output\_storage\_mode) | Storage mode for the MSK cluster |
| <a name="output_zookeeper_connect_string"></a> [zookeeper\_connect\_string](#output\_zookeeper\_connect\_string) | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster |
| <a name="output_zookeeper_connect_string_tls"></a> [zookeeper\_connect\_string\_tls](#output\_zookeeper\_connect\_string\_tls) | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
