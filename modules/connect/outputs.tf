output "connector_arn" {
  description = "ARN of the MSK Connect connector"
  value       = var.create_connector ? aws_mskconnect_connector.this[0].arn : null
}

output "custom_plugin_arn" {
  description = "ARN of the custom plugin"
  value       = var.create_custom_plugin ? aws_mskconnect_custom_plugin.this[0].arn : null
}

output "worker_configuration_arn" {
  description = "ARN of the worker configuration"
  value       = var.create_worker_configuration ? aws_mskconnect_worker_configuration.this[0].arn : null
}

output "service_execution_role_arn" {
  description = "ARN of the MSK Connector IAM Role"
  value       = var.create_connector ? aws_iam_role.msk_connector_service_role[0].arn : null
}
