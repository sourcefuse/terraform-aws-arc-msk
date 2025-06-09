output "msk_cluster_arn" {
  description = "ARN of the MSK cluster"
  value       = module.msk.cluster_arn
}

output "bootstrap_brokers_sasl_iam" {
  description = "Bootstrap brokers for SASL/IAM connections"
  value       = module.msk.bootstrap_brokers_sasl_iam
}

output "zookeeper_connect_string" {
  description = "Zookeeper connection string"
  value       = module.msk.zookeeper_connect_string
}

output "zookeeper_connect_string_tls" {
  description = "Zookeeper TLS connection string"
  value       = module.msk.zookeeper_connect_string_tls
}

output "configuration_latest_revision" {
  description = "Latest revision of the MSK configuration"
  value       = module.msk.configuration_latest_revision
}
