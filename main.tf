#########################################################
# MSK Cluster
##########################################################
module "msk_cluster" {
  source = "./modules/standard"
  count  = var.cluster_type == "provisioned" ? 1 : 0

  # Core settings
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  broker_instance_type   = var.broker_instance_type
  client_subnets         = var.subnet_ids
  security_groups        = var.security_group_ids
  az_distribution        = var.az_distribution

  # Encryption
  client_broker_encryption = var.client_broker_encryption
  in_cluster_encryption    = var.in_cluster_encryption
  create_kms_key           = var.kms_config.create
  kms_key_arn              = var.kms_config.key_arn

  # Storage
  storage_mode               = var.storage_mode
  broker_storage             = var.broker_storage
  storage_autoscaling_config = var.storage_autoscaling_config

  # Monitoring
  enhanced_monitoring = var.enhanced_monitoring
  monitoring_info     = var.monitoring_info

  # Logging
  logging_config = var.logging_config

  # Connectivity
  connectivity_config                    = var.connectivity_config
  vpc_connectivity_client_authentication = var.vpc_connectivity_client_authentication

  # Client Authentication
  client_authentication = var.client_authentication

  # Configuration
  cluster_configuration = var.cluster_configuration

  # Tags
  tags = var.tags

  # SCRAM user (optional)
  scram_username = var.scram_credentials != null ? var.scram_credentials.username : null
  scram_password = var.scram_credentials != null ? var.scram_credentials.password : null


  # VPC Connections
  vpc_connections = var.vpc_connections

  # Cluster policy
  create_cluster_policy = var.create_cluster_policy
  policy_statements     = var.policy_statements
}


#########################################################
# MSK Serverless
##########################################################

module "msk_serverless" {
  source = "./modules/serverless"
  count  = var.cluster_type == "serverless" ? 1 : 0

  cluster_name       = var.cluster_name
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
  sasl_iam_enabled   = var.sasl_iam_enabled
  tags               = var.tags

  create_cluster_policy = var.create_cluster_policy
  policy_statements     = var.policy_statements
}
