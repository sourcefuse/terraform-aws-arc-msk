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
## MSK Connect
################################################################################

module "msk_connect" {
  source = "../.."

  # Flag to control creation
  create_msk_components = true

  create_custom_plugin        = true
  create_worker_configuration = true
  create_connector            = true

  # Custom Plugin
  plugin_name          = "my-custom-plugin"
  plugin_content_type  = "ZIP" # or "JAR" or "ZIP"
  plugin_description   = "Custom plugin for MSK Connect"
  plugin_s3_bucket_arn = module.s3.bucket_arn
  plugin_s3_file_key   = "debezium-mysql-2.3.4.zip"

  # Worker Configuration
  worker_config_name             = "my-worker-config"
  worker_properties_file_content = <<-EOT
  key.converter=org.apache.kafka.connect.json.JsonConverter
  value.converter=org.apache.kafka.connect.json.JsonConverter
  key.converter.schemas.enable=false
  value.converter.schemas.enable=false
EOT
  worker_config_description      = "Worker config for MSK Connect"

  # Connector
  connector_name       = "my-msk-connector"
  kafkaconnect_version = "2.7.1"

  connector_configuration = {
    "connector.class"        = "io.debezium.connector.mysql.MySqlConnector"
    "tasks.max"              = "1"
    "database.hostname"      = aws_db_instance.mysql.address
    "database.port"          = aws_db_instance.mysql.port
    "database.user"          = aws_db_instance.mysql.username
    "database.password"      = aws_db_instance.mysql.password
    "database.server.id"     = "184054"
    "database.server.name"   = "mysql"
    "database.include.list"  = "inventory"
    "include.schema.changes" = "true"

    # Required in Debezium 2.x+
    "schema.history.internal.kafka.bootstrap.servers" = module.msk.bootstrap_brokers_sasl_iam
    "schema.history.internal.kafka.topic"             = "schema-changes.inventory"

    # Optional, for secured MSK
    "schema.history.internal.producer.security.protocol" = "SSL"
    "schema.history.internal.consumer.security.protocol" = "SSL"

    "topic.prefix" = "test"
  }

  # Capacity
  capacity_mode                        = "autoscaling"
  autoscaling_mcu_count                = 1
  autoscaling_min_worker_count         = 1
  autoscaling_max_worker_count         = 5
  scale_in_cpu_utilization_percentage  = 20
  scale_out_cpu_utilization_percentage = 75

  # Networking
  bootstrap_servers = module.msk.bootstrap_brokers_sasl_iam
  security_groups   = [module.security_group.id]
  subnets           = data.aws_subnets.public.ids

  # Authentication and Encryption
  authentication_type = "IAM" # or "NONE"
  encryption_type     = "TLS" # or "PLAINTEXT"

  # Log Delivery
  log_delivery_cloudwatch_enabled = true
  # log_delivery_cloudwatch_log_group = "/aws/msk/connect"

  log_delivery_firehose_enabled         = false
  log_delivery_firehose_delivery_stream = ""

  log_delivery_s3_enabled = true
  log_delivery_s3_bucket  = module.s3.bucket_id
  log_delivery_s3_prefix  = "logs-connect/"

  # IAM Policy ARN

  msk_connector_policy_arns = {
    "custom_policy" = aws_iam_policy.msk_connect_policy.arn
    "cloudwatch"    = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  }

  # Tags
  tags = module.tags.tags

}

################################################################################
## MSK Cluster
################################################################################
module "msk" {
  source = "../.."

  create_msk_cluster     = true
  cluster_name           = "${var.namespace}-${var.environment}-msk"
  kafka_version          = "3.4.0"
  number_of_broker_nodes = 2
  broker_instance_type   = "kafka.t3.small"
  client_subnets         = data.aws_subnets.public.ids
  security_groups        = [module.security_group.id]


  # Enhanced monitoring
  enhanced_monitoring = "PER_BROKER"

  # Authentication settings
  client_authentication = {
    sasl_iam_enabled             = true
    sasl_scram_enabled           = true # if it is set to true - this should create Secrets in Secrets Manager
    allow_unauthenticated_access = false
  }

  # Enable CloudWatch logging
  logging_info = {
    cloudwatch_logs_enabled = true
  }

  # Enable monitoring
  monitoring_info = {
    jmx_exporter_enabled  = true
    node_exporter_enabled = true
  }
  # Create a custom configuration
  configuration_info = {
    create_configuration      = true
    configuration_name        = "my-custom-msk-config"
    configuration_description = "Custom configuration for Kafka cluster"
    server_properties         = <<EOT
auto.create.topics.enable=true
default.replication.factor=3
min.insync.replicas=2
num.partitions=1
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

  name   = "msk-sg-basic"
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


###############################################################################
# DB
###############################################################################
module "mysql_security_group" {
  source  = "sourcefuse/arc-security-group/aws"
  version = "0.0.2"

  name   = "mysql"
  vpc_id = data.aws_vpc.default.id

  ingress_rules = [
    {
      description = "MYSQL"
      cidr_block  = data.aws_vpc.default.cidr_block
      from_port   = 3306
      to_port     = 3306
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

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]{}|:,.<>?~" # Only allowed special characters
}

resource "aws_db_subnet_group" "mysql" {
  name       = "mysql-subnet-group"
  subnet_ids = data.aws_subnets.public.ids

  tags = {
    Name = "MySQLSubnetGroup"
  }
}

resource "aws_db_instance" "mysql" {
  identifier           = "debezium-mysql-db"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "mydb"
  username             = "debezium"
  password             = random_password.db_password.result # use secrets manager or ssm in prod
  port                 = 3306
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.mysql.name
  # vpc_security_group_ids = [aws_security_group.mysql.id]
  vpc_security_group_ids = [module.mysql_security_group.id]
  skip_final_snapshot    = true

  tags = module.tags.tags
}


######################################################
# S3
######################################################

module "s3" {
  source  = "sourcefuse/arc-s3/aws"
  version = "v0.0.4"

  name          = "${var.namespace}-${var.environment}-db-s3-sync-connect-bucket"
  acl           = "private"
  force_destroy = true
  tags          = module.tags.tags
}

resource "aws_s3_object" "this" {

  bucket = module.s3.bucket_id
  key    = "debezium-mysql-2.3.4.zip"
  source = "${path.module}/debezium-mysql-2.3.4.zip"
  acl    = "private"
  # Force update by adding a dynamic tag or timestamp
  metadata = {
    "timestamp" = timestamp() # This will force Terraform to detect a change
  }
}
