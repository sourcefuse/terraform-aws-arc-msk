################################################################################
## Variables
################################################################################

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

variable "client_subnets" {
  description = "A list of subnets to connect to in client VPC. If not provided, private subnets will be fetched using tags"
  type        = list(string)
  default     = []
}

variable "security_groups" {
  description = "A list of security group IDs to associate with the MSK cluster"
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

variable "create_kms_key" {
  description = "Whether to create a new KMS key"
  type        = bool
  default     = false
}


variable "kms_key_arn" {
  description = "KMS Key ARN"
  type        = string
  default     = ""
}


################################################################################
## Tags
################################################################################
variable "tags" {
  description = "A map of tags to assign to the MSK resources"
  type        = map(string)
  default     = {}
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
    sasl_iam_enabled               = optional(bool, false)
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
variable "scram_username" {
  description = "SCRAM username for MSK authentication (optional, will be generated if not provided)"
  type        = string
  default     = null
  sensitive   = true
}

variable "scram_password" {
  description = "SCRAM password for MSK authentication (optional, will be generated if not provided)"
  type        = string
  default     = null
  sensitive   = true
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
# VPC Connections
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
