#########################################################
# MSK Connect
##########################################################

module "msk_connect" {
  source = "./modules/connect"
  count  = var.create_msk_components ? 1 : 0

  create_custom_plugin = var.create_custom_plugin

  create_worker_configuration = var.create_worker_configuration

  create_connector = var.create_connector

  plugin_name          = var.plugin_name
  plugin_content_type  = var.plugin_content_type
  plugin_description   = var.plugin_description
  plugin_s3_bucket_arn = var.plugin_s3_bucket_arn
  plugin_s3_file_key   = var.plugin_s3_file_key

  existing_plugin_arn      = var.existing_plugin_revision
  existing_plugin_revision = var.existing_plugin_revision

  worker_config_name             = var.worker_config_name
  worker_properties_file_content = var.worker_properties_file_content
  worker_config_description      = var.worker_config_description

  connector_name          = var.connector_name
  kafkaconnect_version    = var.kafkaconnect_version
  connector_configuration = var.connector_configuration

  capacity_mode            = var.capacity_mode
  provisioned_mcu_count    = var.provisioned_mcu_count
  provisioned_worker_count = var.provisioned_worker_count

  autoscaling_mcu_count                = var.autoscaling_mcu_count
  autoscaling_min_worker_count         = var.autoscaling_min_worker_count
  autoscaling_max_worker_count         = var.autoscaling_max_worker_count
  scale_in_cpu_utilization_percentage  = var.scale_in_cpu_utilization_percentage
  scale_out_cpu_utilization_percentage = var.scale_out_cpu_utilization_percentage

  bootstrap_servers = var.bootstrap_servers
  security_groups   = var.security_group_ids
  subnets           = var.subnet_ids

  authentication_type = var.authentication_type
  encryption_type     = var.encryption_type

  log_delivery_cloudwatch_enabled = var.log_delivery_cloudwatch_enabled
  cloudwatch_retention_in_days    = var.cloudwatch_retention_in_days

  log_delivery_firehose_enabled         = var.log_delivery_firehose_enabled
  log_delivery_firehose_delivery_stream = var.log_delivery_firehose_delivery_stream

  log_delivery_s3_enabled = var.log_delivery_s3_enabled
  log_delivery_s3_bucket  = var.log_delivery_s3_bucket
  log_delivery_s3_prefix  = var.log_delivery_s3_prefix

  msk_connector_policy_arns = var.msk_connector_policy_arns

  tags = var.tags
}
