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
## MSK Serverless Cluster
################################################################################

module "msk_serverless" {
  # source = "../../modules/serverless"
  source = "../.."

  create_msk_serverless = true

  cluster_name       = "serverless-msk-luster"
  subnet_ids         = data.aws_subnets.public.ids
  security_group_ids = [module.security_group.id]
  sasl_iam_enabled   = true

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

  tags = {
    Environment = "dev"
    Project     = "arc"
  }
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

  tags = {
    Environment = "production"
    Project     = "MSK"
  }
}
