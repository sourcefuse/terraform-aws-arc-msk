################################################################################
## Tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    RepoName = "terraform-aws-msk"
  }
}

################################################################################
## MSK Connector Source - RDS
################################################################################
module "msk_connect" {
  source = "../.."

  # Flag to control creation
  create_msk_components = true

  create_custom_plugin        = true
  create_worker_configuration = false
  create_connector            = true

  # Custom Plugin
  plugin_name          = "jdbc-pg-plugin"
  plugin_content_type  = "ZIP" # or "JAR" or "ZIP"
  plugin_description   = "Custom plugin for MSK Connect"
  plugin_s3_bucket_arn = module.s3.bucket_arn
  plugin_s3_file_key   = "confluentinc-kafka-connect-jdbc-10.6.6.zip"

  # Connector
  connector_name       = "msk-pg-connector"
  kafkaconnect_version = "2.7.1"

  connector_configuration = {
    "connector.class" : "io.confluent.connect.jdbc.JdbcSourceConnector",
    "incrementing.column.name" : "user_id",
    "topic.creation.default.partitions" : "1",
    "connection.password" : data.aws_ssm_parameter.db_password.value,
    "tasks.max" : "1",
    "table.whitelist" : "public.users",
    "mode" : "incrementing",
    "topic.creation.cdc.cleanup.policy" : "delete",
    "topic.prefix" : "cdc_aurora_",
    "poll.interval.ms" : "40000",
    "topic.creation.default.replication.factor" : "2",
    "value.converter" : "org.apache.kafka.connect.json.JsonConverter",
    "key.converter" : "org.apache.kafka.connect.storage.StringConverter",
    "topic.creation.cdc.retention.ms" : "2592000000",
    "topic.creation.cdc.replication.factor" : "2",
    "topic.creation.default.compression.type" : "snappy",
    "topic.creation.default.cleanup.policy" : "delete",
    "topic.creation.cdc.compression.type" : "snappy",
    "topic.creation.default.retention.ms" : "2592000000",
    "topic.creation.groups" : "cdc",
    "connection.user" : data.aws_ssm_parameter.db_username.value,
    "name" : "msk-pg-connector",
    "value.converter.schemas.enable" : "false",
    "topic.creation.cdc.partitions" : "1",
    "connection.url" : "jdbc:postgresql://${data.aws_ssm_parameter.db_endpoint.value}:5432/myapp",
    "topic.creation.cdc.include" : "cdc_aurora_.*"
  }

  # Capacity
  capacity_mode                        = "autoscaling"
  autoscaling_mcu_count                = 1
  autoscaling_min_worker_count         = 1
  autoscaling_max_worker_count         = 5
  scale_in_cpu_utilization_percentage  = 20
  scale_out_cpu_utilization_percentage = 75

  # Networking
  bootstrap_servers  = module.msk.bootstrap_brokers_sasl_iam
  security_group_ids = [module.security_group.id]
  subnet_ids         = data.aws_subnets.public.ids

  # Authentication and Encryption
  authentication_type = "IAM" # or "NONE"
  encryption_type     = "TLS" # or "PLAINTEXT"

  # Log Delivery
  log_delivery_cloudwatch_enabled = true

  # IAM Policy ARN

  msk_connector_policy_arns = {
    "custom_policy" = aws_iam_policy.msk_source_destination_policy.arn
    "cloudwatch"    = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  }

  # Tags
  tags = module.tags.tags

  depends_on = [aws_s3_object.this]
}


################################################################################
## MSK Connector Destination - S3
################################################################################

module "msk_s3_sink" {
  source = "../.."

  # Flag to control creation
  create_msk_components = true

  create_custom_plugin        = true
  create_worker_configuration = false
  create_connector            = true

  # Custom Plugin
  plugin_name          = "s3-sink-plugin"
  plugin_content_type  = "ZIP" # or "JAR" or "ZIP"
  plugin_description   = "Custom plugin for MSK Connect"
  plugin_s3_bucket_arn = module.s3.bucket_arn
  plugin_s3_file_key   = "confluentinc-kafka-connect-s3-10.6.6.zip"


  # Connector
  connector_name       = "msk-s3-sink-connector"
  kafkaconnect_version = "2.7.1"

  connector_configuration = {
    "connector.class" : "io.confluent.connect.s3.S3SinkConnector",
    "errors.log.include.messages" : "true",
    "behavior.on.null.values" : "ignore",
    "s3.region" : "us-east-1",
    "flush.size" : "1",
    "schema.compatibility" : "NONE",
    "topics" : "cdc_aurora_users",
    "tasks.max" : "1",
    "format.class" : "io.confluent.connect.s3.format.json.JsonFormat",
    "partitioner.class" : "io.confluent.connect.storage.partitioner.DefaultPartitioner",
    "errors.tolerance" : "all",
    "value.converter.schemas.enable" : "false",
    "value.converter" : "org.apache.kafka.connect.json.JsonConverter",
    "storage.class" : "io.confluent.connect.s3.storage.S3Storage",
    "errors.log.enable" : "true",
    "key.converter" : "org.apache.kafka.connect.storage.StringConverter",
    "s3.bucket.name" : module.s3.bucket_id
  }

  # Capacity
  capacity_mode                        = "autoscaling"
  autoscaling_mcu_count                = 1
  autoscaling_min_worker_count         = 1
  autoscaling_max_worker_count         = 5
  scale_in_cpu_utilization_percentage  = 20
  scale_out_cpu_utilization_percentage = 75

  # Networking
  bootstrap_servers  = module.msk.bootstrap_brokers_sasl_iam
  security_group_ids = [module.security_group.id]
  subnet_ids         = data.aws_subnets.public.ids

  # Authentication and Encryption
  authentication_type = "IAM" # or "NONE"
  encryption_type     = "TLS" # or "PLAINTEXT"

  # Log Delivery
  log_delivery_cloudwatch_enabled = true

  # IAM Policy ARN
  msk_connector_policy_arns = {
    "custom_policy" = aws_iam_policy.msk_source_destination_policy.arn
    "cloudwatch"    = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  }

  # Tags
  tags = module.tags.tags

  depends_on = [aws_s3_object.this, module.msk_connect]
}

################################################################################
## MSK Cluster
################################################################################
module "msk" {
  source = "../.."

  # create_msk_cluster     = true
  cluster_type           = "provisioned"
  cluster_name           = "basic-${var.namespace}-${var.environment}-msk"
  kafka_version          = "3.4.0"
  number_of_broker_nodes = 2
  broker_instance_type   = "kafka.t3.small"
  subnet_ids             = data.aws_subnets.public.ids
  security_group_ids     = [module.security_group.id]


  # Enhanced monitoring
  enhanced_monitoring = "PER_BROKER"

  # Authentication settings
  client_authentication = {
    sasl_iam_enabled             = true
    sasl_scram_enabled           = false # if it is set to true - this should create Secrets in Secrets Manager
    allow_unauthenticated_access = false
  }

  # Enable CloudWatch logging
  logging_config = {
    cloudwatch_logs_enabled = true
  }

  # Enable monitoring
  monitoring_info = {
    jmx_exporter_enabled  = true
    node_exporter_enabled = true
  }
  # Create a custom configuration
  cluster_configuration = {
    create_configuration      = true
    configuration_name        = "basic-custom-msk-config"
    configuration_description = "Custom configuration for Kafka cluster"
    server_properties         = <<EOT
auto.create.topics.enable=true
default.replication.factor=3
min.insync.replicas=2
num.io.threads=8
num.network.threads=5
num.partitions=20
num.replica.fetchers=2
replica.lag.time.max.ms=30000
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
socket.send.buffer.bytes=102400
unclean.leader.election.enable=false
EOT
  }

  tags = module.tags.tags
}

################################################################################
## Security Group
################################################################################

module "security_group" {
  source  = "sourcefuse/arc-security-group/aws"
  version = "0.0.2"

  name   = "basic-kafka-sg"
  vpc_id = data.aws_vpc.default.id

  ingress_rules = [
    {
      description = "Allow Kafka plaintext"
      cidr_block  = data.aws_vpc.default.cidr_block
      from_port   = 9092
      to_port     = 9092
      ip_protocol = "tcp"
    },
    {
      description = "Allow Kafka TLS"
      cidr_block  = data.aws_vpc.default.cidr_block
      from_port   = 9094
      to_port     = 9094
      ip_protocol = "tcp"
    },
    {
      description = "Allow Kafka SASL"
      cidr_block  = data.aws_vpc.default.cidr_block
      from_port   = 9096
      to_port     = 9098
      ip_protocol = "tcp"
    },
    {
      description = "MYSQL"
      cidr_block  = data.aws_vpc.default.cidr_block
      from_port   = 3306
      to_port     = 3306
      ip_protocol = "tcp"
    },
    {
      description = "postgresql"
      cidr_block  = data.aws_vpc.default.cidr_block
      from_port   = 5432
      to_port     = 5432
      ip_protocol = "tcp"
    },
  ]

  egress_rules = [
    {
      description = "Allow all outbound traffic"
      cidr_block  = "0.0.0.0/0"
      from_port   = -1
      ip_protocol = "-1"
      to_port     = -1
    }
  ]

  tags = module.tags.tags
}


################################################################################
## S3
################################################################################
module "s3" {
  source  = "sourcefuse/arc-s3/aws"
  version = "v0.0.4"

  name          = "${var.namespace}-${var.environment}-msk-s3-db-sink-bucket"
  acl           = "private"
  force_destroy = true
  tags          = module.tags.tags
}

# S3 Object Upload
resource "aws_s3_object" "this" {
  for_each = { for file in var.zip_files : file => file }

  bucket = module.s3.bucket_id
  key    = each.key
  source = "${path.module}/${each.value}"
  acl    = "private"
}
