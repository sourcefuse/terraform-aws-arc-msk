variable "create_custom_plugin" {
  description = "Whether to create the custom plugin"
  type        = bool
  default     = true
}

variable "create_worker_configuration" {
  description = "Whether to create the worker configuration"
  type        = bool
  default     = true
}

variable "create_connector" {
  description = "Whether to create the MSK connector"
  type        = bool
  default     = true
}

variable "plugin_name" {
  description = "Name of the custom plugin"
  type        = string
}

variable "plugin_content_type" {
  description = "Content type of the plugin (ZIP or JAR)"
  type        = string
}

variable "plugin_description" {
  description = "Description of the custom plugin"
  type        = string
  default     = null
}

variable "plugin_s3_bucket_arn" {
  description = "ARN of the S3 bucket containing the plugin"
  type        = string
}

variable "plugin_s3_file_key" {
  description = "S3 key of the plugin file"
  type        = string
}

variable "worker_config_name" {
  description = "Name of the worker configuration"
  type        = string
}

variable "worker_properties_file_content" {
  description = "Contents of the connect-distributed.properties file"
  type        = string
}

variable "worker_config_description" {
  description = "Description of the worker configuration"
  type        = string
  default     = null
}

variable "connector_name" {
  description = "Name of the MSK Connect connector"
  type        = string
}

variable "kafkaconnect_version" {
  description = "Version of Kafka Connect"
  type        = string
}


variable "connector_configuration" {
  description = "Configuration map for the connector"
  type        = map(string)
}

variable "capacity_mode" {
  description = "The capacity mode for MSK Connect: 'autoscaling' or 'provisioned'"
  type        = string
  default     = "autoscaling"
}

variable "provisioned_worker_count" {
  type    = number
  default = 1
}
variable "provisioned_mcu_count" {
  type    = number
  default = 2
}

variable "autoscaling_mcu_count" {
  description = "Number of MCUs per worker"
  type        = number
}

variable "autoscaling_min_worker_count" {
  description = "Minimum number of workers"
  type        = number
}

variable "autoscaling_max_worker_count" {
  description = "Maximum number of workers"
  type        = number
}

variable "scale_in_cpu_utilization_percentage" {
  description = "CPU utilization percentage for scale-in"
  type        = number
}

variable "scale_out_cpu_utilization_percentage" {
  description = "CPU utilization percentage for scale-out"
  type        = number
}

variable "bootstrap_servers" {
  description = "Bootstrap servers for the Kafka cluster"
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "authentication_type" {
  description = "Client authentication type (e.g., NONE, IAM)"
  type        = string
}

variable "encryption_type" {
  description = "Encryption type (e.g., TLS, PLAINTEXT)"
  type        = string
}

variable "log_delivery_cloudwatch_enabled" {
  type        = bool
  description = "Enable CloudWatch log delivery"
  default     = false
}

variable "cloudwatch_retention_in_days" {
  type        = number
  description = "CloudWatch Retention Period Days"
  default     = 7
}

variable "log_delivery_firehose_enabled" {
  type        = bool
  description = "Enable Firehose log delivery"
  default     = false
}

variable "log_delivery_firehose_delivery_stream" {
  type        = string
  description = "Kinesis Firehose delivery stream name"
  default     = ""
}

variable "log_delivery_s3_enabled" {
  type        = bool
  description = "Enable S3 log delivery"
  default     = false
}

variable "log_delivery_s3_bucket" {
  type        = string
  description = "S3 bucket name for log delivery"
  default     = ""
}

variable "log_delivery_s3_prefix" {
  type        = string
  description = "S3 prefix for log delivery"
  default     = ""
}

variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "msk_connector_policy_arns" {
  description = "List of IAM policy ARNs to attach to the MSK Connector execution role"
  type        = map(string)
  default = {
    # "connect-base" = "arn:aws:iam::123456789012:policy/MSKConnectPolicy"
  }
}
