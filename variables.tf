################################################################################
## Variables
################################################################################

variable "cluster_type" {
  description = "Type of MSK cluster. Valid values: provisioned ,serverless or null"
  type        = string
  default     = null
  validation {
    condition     = var.cluster_type == null || contains(["provisioned", "serverless"], var.cluster_type)
    error_message = "cluster_type must be either 'provisioned', 'serverless', or null."
  }
}


variable "storage_mode" {
  description = "Controls storage mode for supported storage tiers. Valid values are: LOCAL or TIERED"
  type        = string
  default     = null
}

variable "enhanced_monitoring" {
  description = "Specify the desired enhanced MSK CloudWatch monitoring level. Valid values: DEFAULT, PER_BROKER, PER_TOPIC_PER_BROKER, or PER_TOPIC_PER_PARTITION"
  type        = string
  default     = "DEFAULT"
}

################################################################################
## MSK Cluster Variables
################################################################################
variable "cluster_name" {
  description = "Name of the MSK cluster"
  type        = string
  default     = null
}

variable "kafka_version" {
  description = "Specify the desired Kafka software version"
  type        = string
  default     = "3.6.0"
}

variable "number_of_broker_nodes" {
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets"
  type        = number
  default     = 2
}

variable "broker_instance_type" {
  description = "Specify the instance type to use for the kafka brokers. e.g. kafka.m5.large"
  type        = string
  default     = "kafka.m5.large"
}

variable "security_group_ids" {
  description = "List of security group IDs (up to five)"
  type        = list(string)
  default     = []
}

variable "az_distribution" {
  description = "The distribution of broker nodes across availability zones. Currently the only valid value is DEFAULT"
  type        = string
  default     = "DEFAULT"
}

variable "client_broker_encryption" {
  description = "Encryption setting for client broker communication. Valid values: TLS, TLS_PLAINTEXT, and PLAINTEXT"
  type        = string
  default     = "TLS"
}

variable "in_cluster_encryption" {
  description = "Whether data communication among broker nodes is encrypted. Default is true"
  type        = bool
  default     = true
}

variable "kms_config" {
  description = "Configuration for KMS key. If `create` is true, a new KMS key will be created. If false, provide an existing `key_arn`."
  type = object({
    create  = optional(bool, false)
    key_arn = optional(string, null)
  })
  default = {
    create = false
  }
}

################################################################################
# Storage Autoscaling
################################################################################

variable "storage_autoscaling_config" {
  description = "Configuration for MSK broker storage autoscaling"
  type = object({
    enabled      = bool
    max_capacity = optional(number, 250)
    role_arn     = optional(string, "")
    target_value = optional(number, 70)
  })
  default = {
    enabled = false
  }
}

############################################################################

############################################################################

variable "client_authentication" {
  description = "Cluster-level client authentication options"
  type = object({
    sasl_scram_enabled             = optional(bool, false)
    sasl_iam_enabled               = optional(bool, true)
    tls_certificate_authority_arns = optional(list(string), [])
    allow_unauthenticated_access   = optional(bool, false)
  })
  default = {}
}

variable "vpc_connectivity_client_authentication" {
  description = "Client authentication for VPC connectivity"
  type = object({
    sasl_scram_enabled             = optional(bool, false)
    sasl_iam_enabled               = optional(bool, false)
    tls_certificate_authority_arns = optional(list(string), [])
  })
  default = {}
}


variable "connectivity_config" {
  description = "Connectivity settings for public and VPC access"
  type = object({
    public_access_enabled = optional(bool, false)
    public_access_type    = optional(string, "SERVICE_PROVIDED_EIPS") # or "DISABLED"
  })
  default = {}
}


variable "logging_config" {
  description = "Logging settings"
  type = object({
    cloudwatch_logs_enabled           = optional(bool, false)
    cloudwatch_log_group              = optional(string)
    cloudwatch_logs_retention_in_days = optional(number)
    firehose_logs_enabled             = optional(bool, false)
    firehose_delivery_stream          = optional(string)
    s3_logs_enabled                   = optional(bool, false)
    s3_logs_bucket                    = optional(string)
    s3_logs_prefix                    = optional(string)
  })
  default = {}
}


variable "cluster_configuration" {
  type = object({
    create_configuration      = bool
    configuration_name        = optional(string)
    configuration_description = optional(string)
    server_properties         = optional(string)
    configuration_arn         = optional(string)
    configuration_revision    = optional(number)
  })
  description = "Configuration block for MSK"
  default = {
    create_configuration = false
  }
}

variable "monitoring_info" {
  description = "Open monitoring exporter settings"
  type = object({
    jmx_exporter_enabled  = optional(bool, false)
    node_exporter_enabled = optional(bool, false)
  })
  default = {}
}


variable "broker_storage" {
  description = "Broker EBS storage configuration"
  type = object({
    volume_size                    = number
    provisioned_throughput_enabled = optional(bool, false)
    volume_throughput              = optional(number)
  })
  default = {
    volume_size = 100
  }
}

##########################################################
# Input Variable: SCRAM UserName Password
##########################################################

variable "scram_credentials" {
  description = <<EOT
SCRAM credentials for MSK authentication.
- username: Optional. Will be generated if not provided.
- password: Optional. Will be generated if not provided.
EOT

  type = object({
    username = optional(string)
    password = optional(string)
  })

  default   = null
  sensitive = true
}

##########################################################
# VPC Connections
##########################################################

variable "vpc_connections" {
  description = <<EOT
A map of MSK VPC connection configurations.
Each key is a unique connection name and value is an object with:
- authentication
- client_subnets
- security_groups
- target_cluster_arn
- vpc_id
- tags (optional)
EOT
  type = map(object({
    authentication  = string
    client_subnets  = list(string)
    security_groups = list(string)
    vpc_id          = string
  }))
  default = {}
}

##########################################################
# Cluster Policy
##########################################################

variable "create_cluster_policy" {
  description = "Whether to create the MSK cluster policy"
  type        = bool
  default     = false
}

variable "policy_statements" {
  description = "List of policy statements for the MSK cluster"
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    principal = map(any)     # Allow "AWS", "Service", etc.
    resources = list(string) # Optional, fallback to cluster_arn
  }))
  default = []
}


#########################################################
# MSK Serverless
##########################################################

variable "subnet_ids" {
  description = "List of subnet IDs in at least two different Availability Zones"
  type        = list(string)
  default     = []

}


variable "sasl_iam_enabled" {
  description = "Enable IAM-based SASL authentication"
  type        = bool
  default     = true
}

#########################################################
# MSK Connect
##########################################################

variable "create_msk_components" {
  description = "Flag to control creation of MSK Standard cluster"
  type        = bool
  default     = false
}


variable "plugin_name" {
  description = "Name of the custom plugin"
  type        = string
  default     = ""
}

variable "plugin_content_type" {
  description = "Content type of the plugin (ZIP or JAR)"
  type        = string
  default     = ""
}

variable "plugin_description" {
  description = "Description of the custom plugin"
  type        = string
  default     = null
}

variable "plugin_s3_bucket_arn" {
  description = "ARN of the S3 bucket containing the plugin"
  type        = string
  default     = ""
}

variable "plugin_s3_file_key" {
  description = "S3 key of the plugin file"
  type        = string
  default     = ""
}

variable "existing_plugin_arn" {
  description = "ARN of an existing custom plugin (used when create_custom_plugin = false)"
  type        = string
  default     = null
}

variable "existing_plugin_revision" {
  description = "Revision of the existing custom plugin"
  type        = number
  default     = null
}

variable "worker_config_name" {
  description = "Name of the worker configuration"
  type        = string
  default     = ""
}

variable "worker_properties_file_content" {
  description = "Contents of the connect-distributed.properties file"
  type        = string
  default     = ""
}

variable "worker_config_description" {
  description = "Description of the worker configuration"
  type        = string
  default     = null
}

variable "connector_name" {
  description = "Name of the MSK Connect connector"
  type        = string
  default     = ""
}

variable "kafkaconnect_version" {
  description = "Version of Kafka Connect"
  type        = string
  default     = ""
}


variable "connector_configuration" {
  description = "Configuration map for the connector"
  type        = map(string)
  default     = {}
}

variable "autoscaling_mcu_count" {
  description = "Number of MCUs per worker"
  type        = number
  default     = 1
}

variable "autoscaling_min_worker_count" {
  description = "Minimum number of workers"
  type        = number
  default     = 2
}

variable "autoscaling_max_worker_count" {
  description = "Maximum number of workers"
  type        = number
  default     = 2
}

variable "scale_in_cpu_utilization_percentage" {
  description = "CPU utilization percentage for scale-in"
  type        = number
  default     = 20
}

variable "scale_out_cpu_utilization_percentage" {
  description = "CPU utilization percentage for scale-out"
  type        = number
  default     = 75
}

variable "bootstrap_servers" {
  description = "Bootstrap servers for the Kafka cluster"
  type        = string
  default     = ""
}

variable "authentication_type" {
  description = "Client authentication type (e.g., NONE, IAM)"
  type        = string
  default     = ""
}

variable "encryption_type" {
  description = "Encryption type (e.g., TLS, PLAINTEXT)"
  type        = string
  default     = ""
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


variable "msk_connector_policy_arns" {
  description = "List of IAM policy ARNs to attach to the MSK Connector execution role"
  type        = map(string)
  default = {
    # "cloudwatch"   = "arn:aws:iam::123456789012:policy/CloudWatchLogsFullAccess"
  }
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

variable "create_custom_plugin" {
  description = "Whether to create the custom plugin"
  type        = bool
  default     = false
}

variable "create_worker_configuration" {
  description = "Whether to create the worker configuration"
  type        = bool
  default     = false
}

variable "create_connector" {
  description = "Whether to create the MSK connector"
  type        = bool
  default     = false
}

################################################################################
## Tags
################################################################################
variable "tags" {
  description = "A map of tags to assign to the MSK resources"
  type        = map(string)
  default     = {}
}
