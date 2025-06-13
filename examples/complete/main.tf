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

###############################################
## MSK Cluster
###############################################
module "msk" {
  source = "../.."

  # create_msk_cluster     = true
  cluster_type           = "provisioned"
  cluster_name           = "complete-msk-cluster"
  kafka_version          = "3.6.0"
  number_of_broker_nodes = 2
  broker_instance_type   = "kafka.m5.large"
  subnet_ids             = data.aws_subnets.public.ids
  security_groups        = [module.security_group.id]

  #Enhanced Monitoring
  enhanced_monitoring = "DEFAULT"

  broker_storage = {
    volume_size                    = 150
    provisioned_throughput_enabled = false
    volume_throughput              = 250
  }

  # Encryption settings
  client_broker_encryption = "TLS" #TLS_PLAINTEXT
  in_cluster_encryption    = true

  kms_config = {
    create = true
  }

  # Authentication settings
  client_authentication = {
    sasl_iam_enabled             = true
    sasl_scram_enabled           = true # if it is set to true - this should create Secrets in Secrets Manager
    allow_unauthenticated_access = false
  }

  # VPC Connectivity Client Authentication
  vpc_connectivity_client_authentication = {
    sasl_iam_enabled   = false
    sasl_scram_enabled = false
  }

  # Enable AutoScaling for Storage
  storage_autoscaling_config = {
    enabled      = true
    max_capacity = 250
  }

  # Monitoring Info (JMX, Node Exporter)
  monitoring_info = {
    jmx_exporter_enabled  = true
    node_exporter_enabled = true
  }

  # Public Connectivity Settings
  connectivity_config = {
    public_access_enabled = true
    public_access_type    = "DISABLED"
  }

  # Logging Configuration
  logging_config = {
    cloudwatch_logs_enabled  = true
    firehose_logs_enabled    = false
    firehose_delivery_stream = null
    s3_logs_enabled          = true
    s3_logs_bucket           = module.s3.bucket_id
    s3_logs_prefix           = "msk-logs/"
  }

  # Custom MSK Configuration
  cluster_configuration = {
    create_configuration      = true
    configuration_name        = "complete-custom-msk-config"
    configuration_description = "Custom configuration for Kafka cluster"
    server_properties         = <<EOT
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
allow.everyone.if.no.acl.found=false
EOT
  }

  # Multi VPC Connections
  # vpc_connections = {
  #   connection-one = {
  #     authentication     = "SASL_IAM"
  #     vpc_id             = aws_vpc.dev.id
  #     client_subnets     = [aws_subnet.dev1.id, aws_subnet.dev2.id]
  #     security_groups    = [aws_security_group.dev.id]
  #   }
  #   # add more Connections as needed
  # }

  # MSK Cluster Policy Configuration
  create_cluster_policy = true

  policy_statements = [
    {
      sid    = "AllowKafka"
      effect = "Allow"
      actions = [
        "kafka:CreateVpcConnection",
        "kafka:GetBootstrapBrokers",
        "kafka:DescribeClusterV2"
      ]
      principal = {
        Service = "kafka.amazonaws.com"
      }
      resources = [] #  Defaults to Cluster ARN
    },
  ]

  # Tags
  tags = module.tags.tags

}

###############################################
## Security Group
###############################################

module "security_group" {
  source  = "sourcefuse/arc-security-group/aws"
  version = "0.0.2"

  name   = "complete-msk-sg"
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
      description = "Allow Zookeeper"
      cidr_block  = data.aws_vpc.default.cidr_block
      from_port   = 2181
      to_port     = 2182
      ip_protocol = "tcp"
    }
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


######################################################
# S3
######################################################

module "s3" {
  source  = "sourcefuse/arc-s3/aws"
  version = "v0.0.4"

  name          = "complete-${var.namespace}-${var.environment}-cluster-logs-bucket"
  acl           = "private"
  force_destroy = true
  tags          = module.tags.tags
}
