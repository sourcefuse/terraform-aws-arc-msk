################################################################################
## MSK Cluster
################################################################################
resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  enhanced_monitoring    = var.enhanced_monitoring
  storage_mode           = var.storage_mode

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    client_subnets  = var.client_subnets
    security_groups = var.security_groups
    az_distribution = var.az_distribution

    storage_info {
      ebs_storage_info {
        volume_size = var.broker_storage.volume_size
        dynamic "provisioned_throughput" {
          for_each = var.broker_storage.provisioned_throughput_enabled ? [1] : []
          content {
            enabled           = true
            volume_throughput = var.broker_storage.volume_throughput
          }
        }
      }
    }

    # Public access configuration - only included if public access is enabled
    dynamic "connectivity_info" {
      # for_each = var.connectivity_info.public_access_enabled ? [1] : []
      for_each = local.enable_public_access
      content {
        public_access { # TODO this is not working - Need to fix this - not getting changed
          type = var.connectivity_info.public_access_type
        }

        dynamic "vpc_connectivity" { # TODO this is not working - Need to fix this - not getting changed
          # for_each = (
          #   var.vpc_connectivity_client_authentication.sasl_scram_enabled ||
          #   var.vpc_connectivity_client_authentication.sasl_iam_enabled ) ? [1] : []
          for_each = local.enable_vpc_connectivity_auth
          content {
            client_authentication {
              dynamic "sasl" {
                for_each = var.vpc_connectivity_client_authentication.sasl_scram_enabled || var.vpc_connectivity_client_authentication.sasl_iam_enabled ? [1] : []
                content {
                  scram = var.vpc_connectivity_client_authentication.sasl_scram_enabled
                  iam   = var.vpc_connectivity_client_authentication.sasl_iam_enabled
                }
              }

              tls = length(var.vpc_connectivity_client_authentication.tls_certificate_authority_arns) > 0
            }
          }
        }

      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = var.client_broker_encryption
      in_cluster    = var.in_cluster_encryption
    }
    encryption_at_rest_kms_key_arn = local.kms_key_arn
  }

  # Client authentication block - only included if any authentication method is enabled
  dynamic "client_authentication" {
    #for_each = (var.client_authentication.sasl_scram_enabled || var.client_authentication.sasl_iam_enabled || length(var.client_authentication.tls_certificate_authority_arns) > 0 || var.client_authentication.allow_unauthenticated_access) ? [1] : []
    for_each = local.enable_client_authentication
    content {
      # SASL block - only included if SASL authentication is enabled
      dynamic "sasl" {
        for_each = var.client_authentication.sasl_scram_enabled || var.client_authentication.sasl_iam_enabled ? [1] : []
        content {
          scram = var.client_authentication.sasl_scram_enabled
          iam   = var.client_authentication.sasl_iam_enabled
        }
      }

      # TLS block - only included if certificate authorities are provided
      dynamic "tls" {
        for_each = length(var.client_authentication.tls_certificate_authority_arns) > 0 ? [1] : []
        content {
          certificate_authority_arns = var.client_authentication.tls_certificate_authority_arns
        }
      }

      unauthenticated = var.client_authentication.allow_unauthenticated_access
    }
  }

  # Configuration info block - only included if both ARN and revision are provided
  # or if we're creating a new configuration
  dynamic "configuration_info" {
    #for_each = var.configuration_info.create_configuration ? [1] : (var.configuration_info.configuration_arn != null && var.configuration_info.configuration_revision != null ? [1] : [])
    for_each = local.enable_configuration_info
    content {
      arn      = var.configuration_info.create_configuration ? aws_msk_configuration.this[0].arn : var.configuration_info.configuration_arn
      revision = var.configuration_info.create_configuration ? aws_msk_configuration.this[0].latest_revision : var.configuration_info.configuration_revision
    }
  }

  # Open monitoring block - always included but with configurable options
  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.monitoring_info.jmx_exporter_enabled
      }
      node_exporter {
        enabled_in_broker = var.monitoring_info.node_exporter_enabled
      }
    }
  }

  # Logging info block - only included if any logging is enabled
  dynamic "logging_info" {
    #for_each = (var.logging_info.cloudwatch_logs_enabled || var.logging_info.firehose_logs_enabled || var.logging_info.s3_logs_enabled) ? [1] : []
    for_each = local.enable_logging_info
    content {
      broker_logs {
        # CloudWatch logs - only configured if enabled
        cloudwatch_logs {
          enabled = var.logging_info.cloudwatch_logs_enabled
          # log_group = var.logging_info.cloudwatch_logs_enabled ? coalesce(var.logging_info.cloudwatch_log_group, local.default_log_group) : null
          log_group = local.log_group_name
        }

        # Firehose logs - only configured if enabled
        firehose {
          enabled         = var.logging_info.firehose_logs_enabled
          delivery_stream = var.logging_info.firehose_logs_enabled ? var.logging_info.firehose_delivery_stream : null
        }

        # S3 logs - only configured if enabled
        s3 {
          enabled = var.logging_info.s3_logs_enabled
          bucket  = var.logging_info.s3_logs_enabled ? var.logging_info.s3_logs_bucket : null
          prefix  = var.logging_info.s3_logs_enabled ? var.logging_info.s3_logs_prefix : null
        }
      }
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags added by AWS
      tags["aws:cloudformation:*"],
    ]
  }
}

################################################################################
## MSK Configuration
################################################################################
resource "aws_msk_configuration" "this" {
  count = var.configuration_info.create_configuration ? 1 : 0

  name              = coalesce(var.configuration_info.configuration_name, local.default_config_name)
  kafka_versions    = [var.kafka_version]
  description       = var.configuration_info.configuration_description
  server_properties = var.configuration_info.server_properties

  lifecycle {
    create_before_destroy = true
  }
}


##########################################################
# VPC Connections
##########################################################

resource "aws_msk_vpc_connection" "this" {
  for_each = var.vpc_connections

  authentication     = each.value.authentication
  client_subnets     = each.value.client_subnets
  security_groups    = each.value.security_groups
  target_cluster_arn = aws_msk_cluster.this.arn
  vpc_id             = each.value.vpc_id
  tags               = var.tags
}


##########################################################
# MSK Cluster Policy
##########################################################
resource "aws_msk_cluster_policy" "this" {
  count       = var.create_cluster_policy && length(var.policy_statements) > 0 ? 1 : 0
  cluster_arn = aws_msk_cluster.this.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      for stmt in var.policy_statements : {
        Sid       = stmt.sid
        Effect    = stmt.effect
        Action    = stmt.actions
        Principal = stmt.principal # This can now be any valid IAM principal structure
        Resource  = length(stmt.resources) > 0 ? stmt.resources : [aws_msk_cluster.this.arn]
      }
    ]
  })
}


##########################################################
# VPC Connections
##########################################################

resource "aws_cloudwatch_log_group" "this" {
  count = var.logging_info.cloudwatch_logs_enabled && var.logging_info.cloudwatch_log_group == null ? 1 : 0

  name              = "${var.cluster_name}-msk-log-group"
  retention_in_days = coalesce(var.logging_info.cloudwatch_logs_retention_in_days, 7)

  tags = var.tags
}
