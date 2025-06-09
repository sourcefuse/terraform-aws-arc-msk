################################################################################
## Tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.project_name

  extra_tags = {
    RepoName = "terraform-aws-msk"
  }
}

################################################################################
## Custom Plugin & Worker Cofiguration
################################################################################
module "msk_connect" {
  source                = "../.."
  create_msk_components = true

  create_custom_plugin        = true
  create_worker_configuration = true
  create_connector            = false

  # MSK Plugin Details
  plugin_name          = "basic-custom-plugin"
  plugin_content_type  = "ZIP" # or "JAR" or "ZIP"
  plugin_description   = "Custom plugin for MSK Connect"
  plugin_s3_bucket_arn = "arn:aws:s3:::msk-bucket-03-05-2025"
  plugin_s3_file_key   = "debezium-mysql-2.3.4.zip"

  # Worker Configuration
  worker_config_name             = "basic-worker-config"
  worker_properties_file_content = <<-EOT
  key.converter=org.apache.kafka.connect.json.JsonConverter
  value.converter=org.apache.kafka.connect.json.JsonConverter
  key.converter.schemas.enable=false
  value.converter.schemas.enable=false
EOT
  worker_config_description      = "Worker config for MSK Connect"

  tags = module.tags.tags
}
