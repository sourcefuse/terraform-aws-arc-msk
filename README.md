# AWS MSK Terraform Module

This Terraform module creates an Amazon Managed Streaming for Apache Kafka (MSK) cluster with configurable options for encryption, authentication, monitoring, and logging.

## Features

- Create an MSK cluster with customizable broker configuration
- Configure encryption in transit and at rest
- Set up authentication methods (SASL/SCRAM, IAM, TLS)
- Enable monitoring with Prometheus JMX and Node exporters
- Configure logging to CloudWatch, Kinesis Firehose, or S3
- Create and manage MSK configurations
- Associate SCRAM secrets for authentication

## Usage

### Basic Usage with Auto-Discovery

```hcl
module "msk" {
  source = "../.."

  cluster_name           = "example-msk-cluster"
  kafka_version          = "3.6.0"
  number_of_broker_nodes = 2
  broker_instance_type   = "kafka.m5.large"
  client_subnets         = data.aws_subnets.private.ids
  security_groups        = [module.security_group.id]
    broker_storage = {
    volume_size                    = 150
  }

  # Enable CloudWatch logging
  logging_info = {
    cloudwatch_logs_enabled  = true
    cloudwatch_log_group     = aws_cloudwatch_log_group.msk_broker_logs.name
  }

  # Enable monitoring
  monitoring_info = {
    jmx_exporter_enabled  = true
    node_exporter_enabled = true
  }

  tags = {
    Environment = "example"
    Project     = "MSK"
  }
}
```

### Usage with Explicit VPC and Subnets

```hcl
module "msk" {
  source = "path/to/terraform-aws-arc-msk"

  cluster_name           = "example-msk-cluster"
  kafka_version          = "3.4.0"
  number_of_broker_nodes = 3
  broker_instance_type   = "kafka.m5.large"
  vpc_id                 = "vpc-12345678"
  client_subnets         = ["subnet-12345678", "subnet-87654321", "subnet-10293847"]
  security_groups        = [module.security_group.id]
  ebs_volume_size        = 1000

  # Enable CloudWatch logging
  cloudwatch_logs_enabled = true
  cloudwatch_log_group    = "msk-broker-logs"

  # Enable monitoring
  jmx_exporter_enabled  = true
  node_exporter_enabled = true

  tags = {
    Environment = "production"
    Project     = "example"
  }
}
```

## Examples

### Simple Example with Auto-Discovery

```hcl
module "security_group" {
  source = "path/to/terraform-aws-arc-security-group"

  name        = "arc-dev-msk-sg"
  description = "Security group for MSK cluster"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_rules = [
    {
      description = "Allow Kafka plaintext"
      cidr_block  = data.aws_vpc.vpc.cidr_block
      from_port   = 9092
      to_port     = 9092
      ip_protocol = "tcp"
    },
    {
      description = "Allow Kafka TLS"
      cidr_block  = data.aws_vpc.vpc.cidr_block
      from_port   = 9094
      to_port     = 9094
      ip_protocol = "tcp"
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
      ip_protocol = "-1"
    }
  ]
}

module "msk" {
  source = "path/to/terraform-aws-arc-msk"

  cluster_name           = "arc-dev-msk"
  kafka_version          = "3.4.0"
  number_of_broker_nodes = 3
  broker_instance_type   = "kafka.t3.small"
  security_groups        = [module.security_group.id]

  # These will be auto-detected from VPC tags
  namespace   = "arc"
  environment = "dev"

  # Enable CloudWatch logging
  cloudwatch_logs_enabled = true
  cloudwatch_log_group    = "arc-dev-msk-logs"

  tags = {
    Environment = "dev"
    Namespace   = "arc"
  }
}
```

### MSK Cluster with Custom Configuration

```hcl
module "msk" {
  source = "path/to/terraform-aws-arc-msk"

  cluster_name           = "example-msk-cluster"
  kafka_version          = "3.4.0"
  number_of_broker_nodes = 3
  broker_instance_type   = "kafka.m5.large"
  vpc_id                 = "vpc-12345678"
  client_subnets         = ["subnet-12345678", "subnet-87654321", "subnet-10293847"]
  security_groups        = [module.security_group.id]
  ebs_volume_size        = 1000

  # Create a custom configuration
  create_configuration     = true
  configuration_name       = "example-msk-config"
  configuration_description = "Example MSK configuration"
  server_properties        = <<EOF
auto.create.topics.enable=true
default.replication.factor=3
min.insync.replicas=2
num.io.threads=8
num.network.threads=5
num.partitions=1
num.replica.fetchers=2
replica.lag.time.max.ms=30000
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
socket.send.buffer.bytes=102400
unclean.leader.election.enable=true
zookeeper.session.timeout.ms=18000
EOF

  tags = {
    Environment = "production"
  }
}
```

### MSK Cluster with SASL/SCRAM Authentication

```hcl
module "msk" {
  source = "path/to/terraform-aws-arc-msk"

  cluster_name           = "example-msk-cluster"
  kafka_version          = "3.4.0"
  number_of_broker_nodes = 3
  broker_instance_type   = "kafka.m5.large"
  client_subnets         = ["subnet-12345678", "subnet-87654321", "subnet-10293847"]
  security_groups        = [module.security_group.id]
  ebs_volume_size        = 1000

  # Enable SASL/SCRAM authentication
  sasl_scram_enabled                     = true
  create_scram_secret_association        = true
  scram_secret_association_secret_arn_list = ["arn:aws:secretsmanager:us-west-2:123456789012:secret:AmazonMSK_example"]

  tags = {
    Environment = "production"
  }
}
```
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
| <a name="module_msk_cluster"></a> [msk\_cluster](#module\_msk\_cluster) | ./modules/standard | n/a |
| <a name="module_msk_connect"></a> [msk\_connect](#module\_msk\_connect) | ./modules/connect | n/a |
| <a name="module_msk_serverless"></a> [msk\_serverless](#module\_msk\_serverless) | ./modules/serverless | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authentication_type"></a> [authentication\_type](#input\_authentication\_type) | Client authentication type (e.g., NONE, IAM) | `string` | `""` | no |
| <a name="input_autoscaling_max_worker_count"></a> [autoscaling\_max\_worker\_count](#input\_autoscaling\_max\_worker\_count) | Maximum number of workers | `number` | `2` | no |
| <a name="input_autoscaling_mcu_count"></a> [autoscaling\_mcu\_count](#input\_autoscaling\_mcu\_count) | Number of MCUs per worker | `number` | `1` | no |
| <a name="input_autoscaling_min_worker_count"></a> [autoscaling\_min\_worker\_count](#input\_autoscaling\_min\_worker\_count) | Minimum number of workers | `number` | `2` | no |
| <a name="input_az_distribution"></a> [az\_distribution](#input\_az\_distribution) | The distribution of broker nodes across availability zones. Currently the only valid value is DEFAULT | `string` | `"DEFAULT"` | no |
| <a name="input_bootstrap_servers"></a> [bootstrap\_servers](#input\_bootstrap\_servers) | Bootstrap servers for the Kafka cluster | `string` | `""` | no |
| <a name="input_broker_instance_type"></a> [broker\_instance\_type](#input\_broker\_instance\_type) | Specify the instance type to use for the kafka brokers. e.g. kafka.m5.large | `string` | `"kafka.m5.large"` | no |
| <a name="input_broker_storage"></a> [broker\_storage](#input\_broker\_storage) | Broker EBS storage configuration | <pre>object({<br/>    volume_size                    = number<br/>    provisioned_throughput_enabled = optional(bool, false)<br/>    volume_throughput              = optional(number)<br/>  })</pre> | <pre>{<br/>  "volume_size": 100<br/>}</pre> | no |
| <a name="input_capacity_mode"></a> [capacity\_mode](#input\_capacity\_mode) | The capacity mode for MSK Connect: 'autoscaling' or 'provisioned' | `string` | `"autoscaling"` | no |
| <a name="input_client_authentication"></a> [client\_authentication](#input\_client\_authentication) | Cluster-level client authentication options | <pre>object({<br/>    sasl_scram_enabled             = optional(bool, false)<br/>    sasl_iam_enabled               = optional(bool, false)<br/>    tls_certificate_authority_arns = optional(list(string), [])<br/>    allow_unauthenticated_access   = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_client_broker_encryption"></a> [client\_broker\_encryption](#input\_client\_broker\_encryption) | Encryption setting for client broker communication. Valid values: TLS, TLS\_PLAINTEXT, and PLAINTEXT | `string` | `"TLS"` | no |
| <a name="input_client_subnets"></a> [client\_subnets](#input\_client\_subnets) | A list of subnets to connect to in client VPC. If not provided, private subnets will be fetched using tags | `list(string)` | `[]` | no |
| <a name="input_cloudwatch_retention_in_days"></a> [cloudwatch\_retention\_in\_days](#input\_cloudwatch\_retention\_in\_days) | CloudWatch Retention Period Days | `number` | `7` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the MSK cluster | `string` | `""` | no |
| <a name="input_configuration_info"></a> [configuration\_info](#input\_configuration\_info) | Configuration block for MSK | <pre>object({<br/>    create_configuration      = bool<br/>    configuration_name        = optional(string)<br/>    configuration_description = optional(string)<br/>    server_properties         = optional(string)<br/>    configuration_arn         = optional(string)<br/>    configuration_revision    = optional(number)<br/>  })</pre> | <pre>{<br/>  "create_configuration": false<br/>}</pre> | no |
| <a name="input_connectivity_info"></a> [connectivity\_info](#input\_connectivity\_info) | Connectivity settings for public and VPC access | <pre>object({<br/>    public_access_enabled = optional(bool, false)<br/>    public_access_type    = optional(string, "SERVICE_PROVIDED_EIPS") # or "DISABLED"<br/>  })</pre> | `{}` | no |
| <a name="input_connector_configuration"></a> [connector\_configuration](#input\_connector\_configuration) | Configuration map for the connector | `map(string)` | `{}` | no |
| <a name="input_connector_name"></a> [connector\_name](#input\_connector\_name) | Name of the MSK Connect connector | `string` | `""` | no |
| <a name="input_create_cluster_policy"></a> [create\_cluster\_policy](#input\_create\_cluster\_policy) | Whether to create the MSK cluster policy | `bool` | `false` | no |
| <a name="input_create_connector"></a> [create\_connector](#input\_create\_connector) | Whether to create the MSK connector | `bool` | `false` | no |
| <a name="input_create_custom_plugin"></a> [create\_custom\_plugin](#input\_create\_custom\_plugin) | Whether to create the custom plugin | `bool` | `false` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Whether to create a new KMS key | `bool` | `false` | no |
| <a name="input_create_msk_cluster"></a> [create\_msk\_cluster](#input\_create\_msk\_cluster) | Flag to control creation of MSK Standard cluster | `bool` | `false` | no |
| <a name="input_create_msk_components"></a> [create\_msk\_components](#input\_create\_msk\_components) | Flag to control creation of MSK Standard cluster | `bool` | `false` | no |
| <a name="input_create_msk_serverless"></a> [create\_msk\_serverless](#input\_create\_msk\_serverless) | Flag to control creation of MSK serverless cluster | `bool` | `false` | no |
| <a name="input_create_worker_configuration"></a> [create\_worker\_configuration](#input\_create\_worker\_configuration) | Whether to create the worker configuration | `bool` | `false` | no |
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | Encryption type (e.g., TLS, PLAINTEXT) | `string` | `""` | no |
| <a name="input_enhanced_monitoring"></a> [enhanced\_monitoring](#input\_enhanced\_monitoring) | Specify the desired enhanced MSK CloudWatch monitoring level. Valid values: DEFAULT, PER\_BROKER, PER\_TOPIC\_PER\_BROKER, or PER\_TOPIC\_PER\_PARTITION | `string` | `"DEFAULT"` | no |
| <a name="input_in_cluster_encryption"></a> [in\_cluster\_encryption](#input\_in\_cluster\_encryption) | Whether data communication among broker nodes is encrypted. Default is true | `bool` | `true` | no |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | Specify the desired Kafka software version | `string` | `"3.6.0"` | no |
| <a name="input_kafkaconnect_version"></a> [kafkaconnect\_version](#input\_kafkaconnect\_version) | Version of Kafka Connect | `string` | `""` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS Key ARN | `string` | `""` | no |
| <a name="input_log_delivery_cloudwatch_enabled"></a> [log\_delivery\_cloudwatch\_enabled](#input\_log\_delivery\_cloudwatch\_enabled) | Enable CloudWatch log delivery | `bool` | `false` | no |
| <a name="input_log_delivery_firehose_delivery_stream"></a> [log\_delivery\_firehose\_delivery\_stream](#input\_log\_delivery\_firehose\_delivery\_stream) | Kinesis Firehose delivery stream name | `string` | `""` | no |
| <a name="input_log_delivery_firehose_enabled"></a> [log\_delivery\_firehose\_enabled](#input\_log\_delivery\_firehose\_enabled) | Enable Firehose log delivery | `bool` | `false` | no |
| <a name="input_log_delivery_s3_bucket"></a> [log\_delivery\_s3\_bucket](#input\_log\_delivery\_s3\_bucket) | S3 bucket name for log delivery | `string` | `""` | no |
| <a name="input_log_delivery_s3_enabled"></a> [log\_delivery\_s3\_enabled](#input\_log\_delivery\_s3\_enabled) | Enable S3 log delivery | `bool` | `false` | no |
| <a name="input_log_delivery_s3_prefix"></a> [log\_delivery\_s3\_prefix](#input\_log\_delivery\_s3\_prefix) | S3 prefix for log delivery | `string` | `""` | no |
| <a name="input_logging_info"></a> [logging\_info](#input\_logging\_info) | Logging settings | <pre>object({<br/>    cloudwatch_logs_enabled           = optional(bool, false)<br/>    cloudwatch_log_group              = optional(string)<br/>    cloudwatch_logs_retention_in_days = optional(number)<br/>    firehose_logs_enabled             = optional(bool, false)<br/>    firehose_delivery_stream          = optional(string)<br/>    s3_logs_enabled                   = optional(bool, false)<br/>    s3_logs_bucket                    = optional(string)<br/>    s3_logs_prefix                    = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_monitoring_info"></a> [monitoring\_info](#input\_monitoring\_info) | Open monitoring exporter settings | <pre>object({<br/>    jmx_exporter_enabled  = optional(bool, false)<br/>    node_exporter_enabled = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_msk_connector_policy_arns"></a> [msk\_connector\_policy\_arns](#input\_msk\_connector\_policy\_arns) | List of IAM policy ARNs to attach to the MSK Connector execution role | `map(string)` | `{}` | no |
| <a name="input_number_of_broker_nodes"></a> [number\_of\_broker\_nodes](#input\_number\_of\_broker\_nodes) | The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets | `number` | `2` | no |
| <a name="input_plugin_content_type"></a> [plugin\_content\_type](#input\_plugin\_content\_type) | Content type of the plugin (ZIP or JAR) | `string` | `""` | no |
| <a name="input_plugin_description"></a> [plugin\_description](#input\_plugin\_description) | Description of the custom plugin | `string` | `null` | no |
| <a name="input_plugin_name"></a> [plugin\_name](#input\_plugin\_name) | Name of the custom plugin | `string` | `""` | no |
| <a name="input_plugin_s3_bucket_arn"></a> [plugin\_s3\_bucket\_arn](#input\_plugin\_s3\_bucket\_arn) | ARN of the S3 bucket containing the plugin | `string` | `""` | no |
| <a name="input_plugin_s3_file_key"></a> [plugin\_s3\_file\_key](#input\_plugin\_s3\_file\_key) | S3 key of the plugin file | `string` | `""` | no |
| <a name="input_policy_statements"></a> [policy\_statements](#input\_policy\_statements) | List of policy statements for the MSK cluster | <pre>list(object({<br/>    sid       = string<br/>    effect    = string<br/>    actions   = list(string)<br/>    principal = map(any)     # Allow "AWS", "Service", etc.<br/>    resources = list(string) # Optional, fallback to cluster_arn<br/>  }))</pre> | `[]` | no |
| <a name="input_provisioned_mcu_count"></a> [provisioned\_mcu\_count](#input\_provisioned\_mcu\_count) | n/a | `number` | `2` | no |
| <a name="input_provisioned_worker_count"></a> [provisioned\_worker\_count](#input\_provisioned\_worker\_count) | n/a | `number` | `1` | no |
| <a name="input_sasl_iam_enabled"></a> [sasl\_iam\_enabled](#input\_sasl\_iam\_enabled) | Enable IAM-based SASL authentication | `bool` | `true` | no |
| <a name="input_scale_in_cpu_utilization_percentage"></a> [scale\_in\_cpu\_utilization\_percentage](#input\_scale\_in\_cpu\_utilization\_percentage) | CPU utilization percentage for scale-in | `number` | `20` | no |
| <a name="input_scale_out_cpu_utilization_percentage"></a> [scale\_out\_cpu\_utilization\_percentage](#input\_scale\_out\_cpu\_utilization\_percentage) | CPU utilization percentage for scale-out | `number` | `75` | no |
| <a name="input_scram_password"></a> [scram\_password](#input\_scram\_password) | SCRAM password for MSK authentication (optional, will be generated if not provided) | `string` | `null` | no |
| <a name="input_scram_username"></a> [scram\_username](#input\_scram\_username) | SCRAM username for MSK authentication (optional, will be generated if not provided) | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs (up to five) | `list(string)` | `[]` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group IDs to associate with the MSK cluster | `list(string)` | `[]` | no |
| <a name="input_storage_autoscaling_config"></a> [storage\_autoscaling\_config](#input\_storage\_autoscaling\_config) | Configuration for MSK broker storage autoscaling | <pre>object({<br/>    enabled      = bool<br/>    max_capacity = optional(number, 250)<br/>    role_arn     = optional(string, "")<br/>    target_value = optional(number, 70)<br/>  })</pre> | <pre>{<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_storage_mode"></a> [storage\_mode](#input\_storage\_mode) | Controls storage mode for supported storage tiers. Valid values are: LOCAL or TIERED | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs in at least two different Availability Zones | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the MSK resources | `map(string)` | `{}` | no |
| <a name="input_vpc_connections"></a> [vpc\_connections](#input\_vpc\_connections) | A map of MSK VPC connection configurations.<br/>Each key is a unique connection name and value is an object with:<br/>- authentication<br/>- client\_subnets<br/>- security\_groups<br/>- target\_cluster\_arn<br/>- vpc\_id<br/>- tags (optional) | <pre>map(object({<br/>    authentication  = string<br/>    client_subnets  = list(string)<br/>    security_groups = list(string)<br/>    vpc_id          = string<br/>  }))</pre> | `{}` | no |
| <a name="input_vpc_connectivity_client_authentication"></a> [vpc\_connectivity\_client\_authentication](#input\_vpc\_connectivity\_client\_authentication) | Client authentication for VPC connectivity | <pre>object({<br/>    sasl_scram_enabled             = optional(bool, false)<br/>    sasl_iam_enabled               = optional(bool, false)<br/>    tls_certificate_authority_arns = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_worker_config_description"></a> [worker\_config\_description](#input\_worker\_config\_description) | Description of the worker configuration | `string` | `null` | no |
| <a name="input_worker_config_name"></a> [worker\_config\_name](#input\_worker\_config\_name) | Name of the worker configuration | `string` | `""` | no |
| <a name="input_worker_properties_file_content"></a> [worker\_properties\_file\_content](#input\_worker\_properties\_file\_content) | Contents of the connect-distributed.properties file | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap_brokers"></a> [bootstrap\_brokers](#output\_bootstrap\_brokers) | Bootstrap brokers |
| <a name="output_bootstrap_brokers_public_sasl_iam"></a> [bootstrap\_brokers\_public\_sasl\_iam](#output\_bootstrap\_brokers\_public\_sasl\_iam) | Public SASL IAM bootstrap brokers |
| <a name="output_bootstrap_brokers_public_sasl_scram"></a> [bootstrap\_brokers\_public\_sasl\_scram](#output\_bootstrap\_brokers\_public\_sasl\_scram) | Public SASL SCRAM bootstrap brokers |
| <a name="output_bootstrap_brokers_public_tls"></a> [bootstrap\_brokers\_public\_tls](#output\_bootstrap\_brokers\_public\_tls) | Public TLS bootstrap brokers |
| <a name="output_bootstrap_brokers_sasl_iam"></a> [bootstrap\_brokers\_sasl\_iam](#output\_bootstrap\_brokers\_sasl\_iam) | SASL IAM bootstrap brokers |
| <a name="output_bootstrap_brokers_sasl_scram"></a> [bootstrap\_brokers\_sasl\_scram](#output\_bootstrap\_brokers\_sasl\_scram) | SASL SCRAM bootstrap brokers |
| <a name="output_bootstrap_brokers_tls"></a> [bootstrap\_brokers\_tls](#output\_bootstrap\_brokers\_tls) | TLS bootstrap brokers |
| <a name="output_bootstrap_brokers_vpc_connectivity_sasl_iam"></a> [bootstrap\_brokers\_vpc\_connectivity\_sasl\_iam](#output\_bootstrap\_brokers\_vpc\_connectivity\_sasl\_iam) | VPC SASL IAM bootstrap brokers |
| <a name="output_bootstrap_brokers_vpc_connectivity_sasl_scram"></a> [bootstrap\_brokers\_vpc\_connectivity\_sasl\_scram](#output\_bootstrap\_brokers\_vpc\_connectivity\_sasl\_scram) | VPC SASL SCRAM bootstrap brokers |
| <a name="output_bootstrap_brokers_vpc_connectivity_tls"></a> [bootstrap\_brokers\_vpc\_connectivity\_tls](#output\_bootstrap\_brokers\_vpc\_connectivity\_tls) | VPC TLS bootstrap brokers |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | Amazon Resource Name (ARN) of the MSK cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | MSK Cluster Name |
| <a name="output_cluster_policy_id"></a> [cluster\_policy\_id](#output\_cluster\_policy\_id) | ID of the MSK cluster policy |
| <a name="output_cluster_uuid"></a> [cluster\_uuid](#output\_cluster\_uuid) | UUID of the MSK cluster |
| <a name="output_configuration_latest_revision"></a> [configuration\_latest\_revision](#output\_configuration\_latest\_revision) | Latest revision of the MSK configuration |
| <a name="output_current_version"></a> [current\_version](#output\_current\_version) | Current version of the MSK cluster |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | KMS Key Alias |
| <a name="output_msk_connect_connector_arn"></a> [msk\_connect\_connector\_arn](#output\_msk\_connect\_connector\_arn) | ARN of the MSK Connect connector |
| <a name="output_msk_connect_custom_plugin_arn"></a> [msk\_connect\_custom\_plugin\_arn](#output\_msk\_connect\_custom\_plugin\_arn) | ARN of the custom plugin |
| <a name="output_msk_connect_service_execution_role_arn"></a> [msk\_connect\_service\_execution\_role\_arn](#output\_msk\_connect\_service\_execution\_role\_arn) | ARN of the MSK Connector IAM Role |
| <a name="output_msk_connect_worker_configuration_arn"></a> [msk\_connect\_worker\_configuration\_arn](#output\_msk\_connect\_worker\_configuration\_arn) | ARN of the worker configuration |
| <a name="output_serverless_bootstrap_brokers_sasl_iam"></a> [serverless\_bootstrap\_brokers\_sasl\_iam](#output\_serverless\_bootstrap\_brokers\_sasl\_iam) | Bootstrap broker endpoints with SASL IAM |
| <a name="output_serverless_cluster_uuid"></a> [serverless\_cluster\_uuid](#output\_serverless\_cluster\_uuid) | UUID of the MSK serverless cluster |
| <a name="output_serverless_msk_cluster_arn"></a> [serverless\_msk\_cluster\_arn](#output\_serverless\_msk\_cluster\_arn) | ARN of the MSK serverless cluster |
| <a name="output_storage_mode"></a> [storage\_mode](#output\_storage\_mode) | Storage mode for the MSK cluster |
| <a name="output_zookeeper_connect_string"></a> [zookeeper\_connect\_string](#output\_zookeeper\_connect\_string) | Zookeeper connect string |
| <a name="output_zookeeper_connect_string_tls"></a> [zookeeper\_connect\_string\_tls](#output\_zookeeper\_connect\_string\_tls) | Zookeeper TLS connect string |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning  
This project uses a `.version` file at the root of the repo which the pipeline reads from and does a git tag.  

When you intend to commit to `main`, you will need to increment this version. Once the project is merged,
the pipeline will kick off and tag the latest git commit.  

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
  ```sh
  pre-commit install
  ```

### Versioning

while Contributing or doing git commit please specify the breaking change in your commit message whether its major,minor or patch

For Example

```sh
git commit -m "your commit message #major"
```
By specifying this , it will bump the version and if you don't specify this in your commit message then by default it will consider patch and will bump that accordingly

### Tests
- Tests are available in `test` directory
- Configure the dependencies
  ```sh
  cd test/
  go mod init github.com/sourcefuse/terraform-aws-refarch-<module_name>
  go get github.com/gruntwork-io/terratest/modules/terraform
  ```
- Now execute the test  
  ```sh
  go test -timeout  30m
  ```

## Authors

This project is authored by:
- SourceFuse ARC Team
