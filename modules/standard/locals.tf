################################################################################
## Local Variables
################################################################################
locals {

  # kms key
  kms_key_arn = var.kms_key_arn != null ? var.kms_key_arn : (var.create_kms_key ? aws_kms_key.msk[0].arn : null)

  # Default configuration name if not provided
  default_config_name = "${var.cluster_name}-config"

  # SCRAM Authentication Settings
  scram_enabled            = (var.client_authentication.sasl_scram_enabled) ? true : false
  scram_username_generated = local.scram_enabled && (var.scram_username == null || var.scram_username == "") ? try(random_pet.scram_username[0].id, null) : null
  scram_password_generated = local.scram_enabled && (var.scram_password == null || var.scram_password == "") ? try(random_password.scram_password[0].result, null) : null
  scram_username           = local.scram_enabled ? coalesce(var.scram_username, local.scram_username_generated) : ""
  scram_password           = local.scram_enabled ? coalesce(var.scram_password, local.scram_password_generated) : ""

  # Used for enabling public access
  enable_public_access = var.connectivity_info.public_access_enabled ? [1] : []

  # Used for enabling VPC connectivity authentication
  enable_vpc_connectivity_auth = (var.vpc_connectivity_client_authentication.sasl_scram_enabled || var.vpc_connectivity_client_authentication.sasl_iam_enabled) ? [1] : []

  # Used for enabling client_authentication block
  enable_client_authentication = (var.client_authentication.sasl_scram_enabled || var.client_authentication.sasl_iam_enabled || length(var.client_authentication.tls_certificate_authority_arns) > 0 || var.client_authentication.allow_unauthenticated_access) ? [1] : []

  # Used for enabling configuration_info block
  enable_configuration_info = var.configuration_info.create_configuration ? [1] : (var.configuration_info.configuration_arn != null && var.configuration_info.configuration_revision != null ? [1] : [])

  # Used for enabling logging_info block
  enable_logging_info = (var.logging_info.cloudwatch_logs_enabled || var.logging_info.firehose_logs_enabled || var.logging_info.s3_logs_enabled) ? [1] : []

  # Used for pass the Cloudwatch Log Group Name
  log_group_name = var.logging_info.cloudwatch_logs_enabled ? (var.logging_info.cloudwatch_log_group != null ? var.logging_info.cloudwatch_log_group : aws_cloudwatch_log_group.this[0].name) : null
}
