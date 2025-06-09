##########################################################
# MSK Serverless
##########################################################

output "serverless_msk_cluster_arn" {
  value       = aws_msk_serverless_cluster.this.arn
  description = "ARN of the MSK serverless cluster"
}

output "serverless_bootstrap_brokers_sasl_iam" {
  value       = aws_msk_serverless_cluster.this.bootstrap_brokers_sasl_iam
  description = "Bootstrap broker endpoints with SASL IAM"
}

output "serverless_cluster_uuid" {
  value       = aws_msk_serverless_cluster.this.cluster_uuid
  description = "UUID of the MSK cluster"
}
