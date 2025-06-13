################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "environment" {
  type        = string
  default     = "poc"
  description = "Environment name, e.g. 'prod', 'staging', 'dev', 'test'"
}

variable "namespace" {
  type        = string
  default     = "arc"
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'arc'"
}

variable "zip_files" {
  type = list(string)
  default = [
    "confluentinc-kafka-connect-s3-10.6.6.zip",
    "confluentinc-kafka-connect-jdbc-10.6.6.zip",
  ]
}
