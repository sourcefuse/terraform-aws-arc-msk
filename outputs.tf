output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].arn : ""
  sensitive   = true
}

output "bootstrap_brokers" {
  description = "Bootstrap brokers"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].bootstrap_brokers : ""
}

output "bootstrap_brokers_tls" {
  description = "TLS bootstrap brokers"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].bootstrap_brokers_tls : ""
}

output "bootstrap_brokers_sasl_scram" {
  description = "SASL SCRAM bootstrap brokers"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].bootstrap_brokers_sasl_scram : ""
}

output "bootstrap_brokers_sasl_iam" {
  description = "SASL IAM bootstrap brokers"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].bootstrap_brokers_sasl_iam : ""
}

output "bootstrap_brokers_public_tls" {
  description = "Public TLS bootstrap brokers"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].bootstrap_brokers_public_tls : ""
}

output "bootstrap_brokers_public_sasl_scram" {
  description = "Public SASL SCRAM bootstrap brokers"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].bootstrap_brokers_public_sasl_scram : ""
}

output "bootstrap_brokers_public_sasl_iam" {
  description = "Public SASL IAM bootstrap brokers"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].bootstrap_brokers_public_sasl_iam : ""
}

output "bootstrap_brokers_vpc_connectivity_tls" {
  description = "VPC TLS bootstrap brokers"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].bootstrap_brokers_vpc_connectivity_tls : ""
}

output "bootstrap_brokers_vpc_connectivity_sasl_scram" {
  description = "VPC SASL SCRAM bootstrap brokers"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].bootstrap_brokers_vpc_connectivity_sasl_scram : ""
}

output "bootstrap_brokers_vpc_connectivity_sasl_iam" {
  description = "VPC SASL IAM bootstrap brokers"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].bootstrap_brokers_vpc_connectivity_sasl_iam : ""
}

output "zookeeper_connect_string" {
  description = "Zookeeper connect string"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].zookeeper_connect_string : ""
}

output "zookeeper_connect_string_tls" {
  description = "Zookeeper TLS connect string"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].zookeeper_connect_string_tls : ""
}

output "configuration_latest_revision" {
  description = "Latest revision of the MSK configuration"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].configuration_latest_revision : ""
}

output "cluster_name" {
  description = "MSK Cluster Name"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].cluster_name : ""
}

output "storage_mode" {
  description = "Storage mode for the MSK cluster"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].storage_mode : ""
}

output "current_version" {
  description = "Current version of the MSK cluster"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].current_version : ""
}

output "cluster_uuid" {
  description = "UUID of the MSK cluster"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].cluster_uuid : ""
}

output "kms_key_alias" {
  description = "KMS Key Alias"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].kms_key_alias : ""
}

output "cluster_policy_id" {
  description = "ID of the MSK cluster policy"
  value       = length(module.msk_cluster) > 0 ? module.msk_cluster[0].msk_cluster_policy_id : ""
}


#########################################################
# MSK Serverless
##########################################################

output "serverless_msk_cluster_arn" {
  value       = length(module.msk_serverless) > 0 ? module.msk_serverless[0].serverless_msk_cluster_arn : ""
  description = "ARN of the MSK serverless cluster"
}

output "serverless_bootstrap_brokers_sasl_iam" {
  value       = length(module.msk_serverless) > 0 ? module.msk_serverless[0].serverless_bootstrap_brokers_sasl_iam : ""
  description = "Bootstrap broker endpoints with SASL IAM"
}

output "serverless_cluster_uuid" {
  value       = length(module.msk_serverless) > 0 ? module.msk_serverless[0].serverless_cluster_uuid : null
  description = "UUID of the MSK serverless cluster"
}


#########################################################
# MSK Connect
##########################################################

output "msk_connect_connector_arn" {
  description = "ARN of the MSK Connect connector"
  value       = var.create_msk_components ? module.msk_connect[0].connector_arn : null
}

output "msk_connect_custom_plugin_arn" {
  description = "ARN of the custom plugin"
  value       = var.create_msk_components ? module.msk_connect[0].custom_plugin_arn : null
}

output "msk_connect_worker_configuration_arn" {
  description = "ARN of the worker configuration"
  value       = var.create_msk_components ? module.msk_connect[0].worker_configuration_arn : null
}

output "msk_connect_service_execution_role_arn" {
  description = "ARN of the MSK Connector IAM Role"
  value       = var.create_msk_components ? module.msk_connect[0].service_execution_role_arn : null
}
