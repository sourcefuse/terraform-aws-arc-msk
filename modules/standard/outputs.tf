output "arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = aws_msk_cluster.this.arn
}

output "bootstrap_brokers" {
  description = "A comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster"
  value       = aws_msk_cluster.this.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to bootstrap connectivity to the kafka cluster"
  value       = aws_msk_cluster.this.bootstrap_brokers_tls
}

output "bootstrap_brokers_sasl_scram" {
  description = "A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs kafka brokers suitable to bootstrap connectivity to the kafka cluster"
  value       = var.client_authentication.sasl_scram_enabled ? aws_msk_cluster.this.bootstrap_brokers_sasl_scram : null
}

output "bootstrap_brokers_sasl_iam" {
  description = "A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs kafka brokers suitable to bootstrap connectivity to the kafka cluster"
  value       = var.client_authentication.sasl_iam_enabled ? aws_msk_cluster.this.bootstrap_brokers_sasl_iam : null
}

output "bootstrap_brokers_public_tls" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs for public access"
  value       = var.connectivity_info.public_access_enabled ? aws_msk_cluster.this.bootstrap_brokers_public_tls : null
}

output "bootstrap_brokers_public_sasl_scram" {
  description = "A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs for public access"
  value       = var.connectivity_info.public_access_enabled && var.client_authentication.sasl_scram_enabled ? aws_msk_cluster.this.bootstrap_brokers_public_sasl_scram : null
}

output "bootstrap_brokers_public_sasl_iam" {
  description = "A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs for public access"
  value       = var.connectivity_info.public_access_enabled && var.client_authentication.sasl_iam_enabled ? aws_msk_cluster.this.bootstrap_brokers_public_sasl_iam : null
}

output "bootstrap_brokers_vpc_connectivity_tls" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs for VPC connectivity"
  value       = aws_msk_cluster.this.bootstrap_brokers_vpc_connectivity_tls
}

output "bootstrap_brokers_vpc_connectivity_sasl_scram" {
  description = "A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs for VPC connectivity"
  value       = var.client_authentication.sasl_scram_enabled ? aws_msk_cluster.this.bootstrap_brokers_vpc_connectivity_sasl_scram : null
}

output "bootstrap_brokers_vpc_connectivity_sasl_iam" {
  description = "A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs for VPC connectivity"
  value       = var.client_authentication.sasl_iam_enabled ? aws_msk_cluster.this.bootstrap_brokers_vpc_connectivity_sasl_iam : null
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster"
  value       = aws_msk_cluster.this.zookeeper_connect_string
}

output "zookeeper_connect_string_tls" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS"
  value       = aws_msk_cluster.this.zookeeper_connect_string_tls
}


output "configuration_latest_revision" {
  description = "Latest revision of the MSK configuration"
  value       = var.configuration_info.create_configuration ? aws_msk_configuration.this[0].latest_revision : var.configuration_info.configuration_revision
}


output "cluster_name" {
  description = "Name of the MSK cluster"
  value       = aws_msk_cluster.this.cluster_name
}

output "storage_mode" {
  description = "Storage mode for the MSK cluster"
  value       = aws_msk_cluster.this.storage_mode
}

output "current_version" {
  description = "Current version of the MSK Cluster used for updates"
  value       = aws_msk_cluster.this.current_version
}

output "cluster_uuid" {
  description = "UUID of the MSK cluster, for use in IAM policies"
  value       = aws_msk_cluster.this.cluster_uuid
}

output "kms_key_alias" {
  value       = try(aws_kms_alias.msk[0].name, null)
  description = "Alias for the MSK KMS key"
}

output "msk_cluster_policy_id" {
  description = "The ID of the MSK cluster policy"
  value       = try(aws_msk_cluster_policy.this[0].id, null)
}
