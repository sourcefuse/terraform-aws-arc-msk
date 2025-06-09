output "msk_connect_custom_plugin_arn" {
  description = "ARN of the custom plugin"
  value       = module.msk_connect.msk_connect_custom_plugin_arn
}

output "msk_connect_worker_configuration_arn" {
  description = "ARN of the worker configuration"
  value       = module.msk_connect.msk_connect_worker_configuration_arn
}
