#########################################################
# MSK Serverless
##########################################################
variable "cluster_name" {
  description = "Name of the MSK cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs in at least two different Availability Zones"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs (up to five)"
  type        = list(string)
  default     = []
}

variable "sasl_iam_enabled" {
  description = "Enable IAM-based SASL authentication"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the MSK resources"
  type        = map(string)
  default     = {}
}


variable "create_cluster_policy" {
  description = "Whether to create an MSK cluster policy"
  type        = bool
  default     = false
}

variable "policy_statements" {
  description = "List of policy statements for MSK cluster access"
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    principal = map(any) # Allow "AWS", "Service", etc.
    resources = list(string)
  }))
}
