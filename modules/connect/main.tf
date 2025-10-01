#########################################################
# MSK Connect Plugin
##########################################################

resource "aws_mskconnect_custom_plugin" "this" {
  count        = var.create_custom_plugin ? 1 : 0
  name         = var.plugin_name
  content_type = var.plugin_content_type
  description  = var.plugin_description

  location {
    s3 {
      bucket_arn = var.plugin_s3_bucket_arn
      file_key   = var.plugin_s3_file_key
    }
  }

  tags = var.tags
}

#########################################################
# MSK Connect Worker Configuration
##########################################################

resource "aws_mskconnect_worker_configuration" "this" {
  count                   = var.create_worker_configuration ? 1 : 0
  name                    = var.worker_config_name
  properties_file_content = var.worker_properties_file_content
  description             = var.worker_config_description

  tags = var.tags
}

#########################################################
# MSK Connect
##########################################################

resource "aws_mskconnect_connector" "this" {
  count = var.create_connector ? 1 : 0

  name                       = var.connector_name
  kafkaconnect_version       = var.kafkaconnect_version
  service_execution_role_arn = aws_iam_role.msk_connector_service_role[0].arn

  connector_configuration = var.connector_configuration

  capacity {
    dynamic "autoscaling" {
      for_each = var.capacity_mode == "autoscaling" ? [1] : []
      content {
        mcu_count        = var.autoscaling_mcu_count
        min_worker_count = var.autoscaling_min_worker_count
        max_worker_count = var.autoscaling_max_worker_count

        scale_in_policy {
          cpu_utilization_percentage = var.scale_in_cpu_utilization_percentage
        }

        scale_out_policy {
          cpu_utilization_percentage = var.scale_out_cpu_utilization_percentage
        }
      }
    }

    dynamic "provisioned_capacity" {
      for_each = var.capacity_mode == "provisioned" ? [1] : []
      content {
        mcu_count    = var.provisioned_mcu_count
        worker_count = var.provisioned_worker_count
      }
    }
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = var.bootstrap_servers

      vpc {
        security_groups = var.security_groups
        subnets         = var.subnets
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = var.authentication_type
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = var.encryption_type
  }

  dynamic "plugin" {
    for_each = var.create_custom_plugin || (var.existing_plugin_arn != null && var.existing_plugin_arn != "") ? [1] : []
    content {
      custom_plugin {
        arn      = var.create_custom_plugin ? aws_mskconnect_custom_plugin.this[0].arn : var.existing_plugin_arn
        revision = var.create_custom_plugin ? aws_mskconnect_custom_plugin.this[0].latest_revision : var.existing_plugin_revision
      }
    }
  }

  dynamic "worker_configuration" {
    for_each = var.create_worker_configuration ? [1] : []
    content {
      arn      = aws_mskconnect_worker_configuration.this[0].arn
      revision = aws_mskconnect_worker_configuration.this[0].latest_revision
    }
  }

  log_delivery {
    worker_log_delivery {
      cloudwatch_logs {
        enabled   = var.log_delivery_cloudwatch_enabled
        log_group = var.log_delivery_cloudwatch_enabled ? aws_cloudwatch_log_group.msk_connector[0].name : null
      }

      firehose {
        enabled         = var.log_delivery_firehose_enabled
        delivery_stream = var.log_delivery_firehose_delivery_stream
      }

      s3 {
        enabled = var.log_delivery_s3_enabled
        bucket  = var.log_delivery_s3_bucket
        prefix  = var.log_delivery_s3_prefix
      }
    }
  }

  tags = var.tags
}
#########################################################
# Cloudwatch Log Group
##########################################################
resource "aws_cloudwatch_log_group" "msk_connector" {
  count = var.log_delivery_cloudwatch_enabled ? 1 : 0

  name              = "/aws/msk/${var.connector_name}"
  retention_in_days = var.cloudwatch_retention_in_days
  tags              = var.tags
}
