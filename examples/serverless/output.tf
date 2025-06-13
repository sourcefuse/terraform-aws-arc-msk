output "serverless_msk_cluster_arn" {
  value       = module.msk_serverless.serverless_msk_cluster_arn
  description = "ARN of the MSK serverless cluster"
}

output "serverless_bootstrap_brokers_sasl_iam" {
  value       = module.msk_serverless.serverless_bootstrap_brokers_sasl_iam
  description = "Bootstrap broker endpoints with SASL IAM"
}

output "serverless_cluster_uuid" {
  value       = module.msk_serverless.serverless_cluster_uuid
  description = "UUID of the MSK serverless cluster"
}
