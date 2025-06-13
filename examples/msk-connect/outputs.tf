output "msk_cluster_arn" {
  description = "ARN of the MSK cluster"
  value       = module.msk.cluster_arn
}

output "bootstrap_brokers_sasl_iam" {
  description = "Bootstrap brokers for plaintext connections"
  value       = module.msk.bootstrap_brokers_sasl_iam
}

output "zookeeper_connect_string" {
  description = "Zookeeper connection string"
  value       = module.msk.zookeeper_connect_string
}

output "msk_connect_connector_arn" {
  description = "ARN of the MSK Connect connector"
  value       = module.msk_connect.msk_connect_connector_arn
}

output "msk_connect_custom_plugin_arn" {
  description = "ARN of the custom plugin"
  value       = module.msk_connect.msk_connect_custom_plugin_arn
}

output "msk_connect_worker_configuration_arn" {
  description = "ARN of the worker configuration"
  value       = module.msk_connect.msk_connect_worker_configuration_arn
}

output "msk_connect_service_execution_role_arn" {
  description = "ARN of the MSK Connector IAM Role"
  value       = module.msk_connect.msk_connect_service_execution_role_arn
}
