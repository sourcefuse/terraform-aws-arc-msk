# Usage

## Basic Usage

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

  tags = {
    Environment = "production"
  }
}
```

## Security Group Configuration

It's recommended to create a dedicated security group for your MSK cluster using the `terraform-aws-arc-security-group` module:

```hcl
module "security_group" {
  source = "path/to/terraform-aws-arc-security-group"

  name   = "msk-sg"
  vpc_id = "vpc-12345678"

  ingress_rules = [
    {
      description = "Allow Kafka plaintext"
      cidr_block  = "10.0.0.0/16"
      from_port   = 9092
      to_port     = 9092
      ip_protocol = "tcp"
    },
    {
      description = "Allow Kafka TLS"
      cidr_block  = "10.0.0.0/16"
      from_port   = 9094
      to_port     = 9094
      ip_protocol = "tcp"
    },
    {
      description = "Allow Kafka SASL"
      cidr_block  = "10.0.0.0/16"
      from_port   = 9096
      to_port     = 9098
      ip_protocol = "tcp"
    },
    {
      description = "Allow Zookeeper"
      cidr_block  = "10.0.0.0/16"
      from_port   = 2181
      to_port     = 2182
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
```

## Custom Configuration

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

## Authentication and Encryption

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

  # Encryption settings
  client_broker_encryption = "TLS"
  in_cluster_encryption    = true
  kms_key_arn              = "arn:aws:kms:us-west-2:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"

  # Authentication settings
  sasl_scram_enabled                     = true
  create_scram_secret_association        = true
  scram_secret_association_secret_arn_list = ["arn:aws:secretsmanager:us-west-2:123456789012:secret:AmazonMSK_example"]

  tags = {
    Environment = "production"
  }
}
```

## Monitoring and Logging

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

  # Enable monitoring
  jmx_exporter_enabled  = true
  node_exporter_enabled = true

  # Enable CloudWatch logging
  cloudwatch_logs_enabled = true
  cloudwatch_log_group    = "msk-broker-logs"

  # Enable S3 logging
  s3_logs_enabled = true
  s3_logs_bucket  = "my-msk-logs-bucket"
  s3_logs_prefix  = "msk-logs"

  tags = {
    Environment = "production"
  }
}
```
