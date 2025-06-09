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
module "msk" {
  source                 = "../.."
  create_msk_cluster     = true
  cluster_name           = "example-msk-cluster"
  kafka_version          = "3.6.0"
  number_of_broker_nodes = 2
  broker_instance_type   = "kafka.m5.large"
  client_subnets         = data.aws_subnets.public.ids
  security_groups        = [module.security_group.id]
  broker_storage = {
    volume_size = 150
  }

  client_authentication = {
    sasl_scram_enabled           = true # When set to true, this will create secrets in AWS Secrets Manager.
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

  tags = module.tags.tags
}

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
