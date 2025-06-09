# Terraform AWS ARC MSK Module Usage Guide

## Introduction

### Purpose of the Document

This document provides guidelines and instructions for users looking to implement the Terraform AWS ARC MSK (Managed Streaming for Apache Kafka) module.

### Module Overview

The Terraform AWS ARC MSK module provides a secure and modular foundation for deploying Amazon MSK (Managed Streaming for Apache Kafka) clusters on AWS. It supports both standard and serverless MSK clusters with comprehensive configuration options for encryption, authentication, monitoring, and logging.

### Prerequisites

Before using this module, ensure you have the following:

- AWS credentials configured.
- Terraform installed (version > 1.4, < 2.0.0).
- A working knowledge of AWS VPC, Apache Kafka, MSK, and Terraform concepts.

## Getting Started

### Module Source

To use the module in your Terraform configuration, include the following source block:

```hcl
module "msk" {
  source  = "sourcefuse/arc-msk/aws"
  version = "0.0.1"

  create_msk_cluster     = true
  cluster_name           = "example-msk-cluster"
  kafka_version          = "3.6.0"
  number_of_broker_nodes = 2
  broker_instance_type   = "kafka.m5.large"
  client_subnets         = data.aws_subnets.public.ids
  security_groups        = [module.security_group.id]
  broker_storage = {
    volume_size = 150
  }

  client_authentication = {
    sasl_scram_enabled           = true # When set to true, this will create secrets in AWS Secrets Manager.
    allow_unauthenticated_access = false
  }
  # Enable CloudWatch logging
  logging_info = {
    cloudwatch_logs_enabled = true
  }

  # Enable monitoring
  monitoring_info = {
    jmx_exporter_enabled  = true
    node_exporter_enabled = true
  }

  tags = module.tags.tags
}
```

Refer to the [Terraform Registry](https://registry.terraform.io/modules/sourcefuse/arc-msk/aws/latest) for the latest version.

### Integration with Existing Terraform Configurations

## Integration with Existing Terraform Configurations
Integrate the module with your existing Terraform mono repo configuration, follow the steps below:

- Create a new folder in terraform/ named msk.
- Create the required files, see the examples to base off of.
- Configure with your backend:
   - Create the environment backend configuration file: config.<environment>.hcl
   - region: Where the backend resides
   - key: <working_directory>/terraform.tfstate
   - bucket: Bucket name where the terraform state will reside
   - dynamodb_table: Lock table so there are not duplicate tfplans in the mix
   - encrypt: Encrypt all traffic to and from the backend

### Required AWS Permissions

Ensure that the AWS credentials used to execute Terraform have the necessary permissions to create, list and modify:

- Amazon MSK clusters and configurations
- IAM roles and policies
- KMS keys (if encryption is enabled)
- CloudWatch logs and metrics
- Security groups and VPC resources
- Secrets Manager resources (for SASL/SCRAM authentication)

## Module Configuration

### Input Variables

For a list of input variables, see the README [Inputs](https://github.com/sourcefuse/terraform-aws-arc-msk#inputs) section.

### Output Values

For a list of outputs, see the README [Outputs](https://github.com/sourcefuse/terraform-aws-arc-msk#outputs) section.

## Module Usage

### Basic Usage

For basic usage, see the [example](https://github.com/sourcefuse/terraform-aws-arc-msk/tree/main/examples/simple) folder.

This example will create:

- An MSK cluster with customizable broker configuration
- Client authentication with SASL/SCRAM
- CloudWatch logging
- Prometheus monitoring with JMX and Node exporters

### Tips and Recommendations

- The module focuses on provisioning secure and scalable MSK clusters. The convention-based approach enables downstream services to easily connect to the Kafka cluster. Adjust the configuration parameters as needed for your specific use case.
- Consider using the storage autoscaling feature for production workloads to handle growing data volumes.
- For high availability, deploy the MSK cluster across multiple availability zones.
- Use appropriate authentication methods (SASL/SCRAM, IAM, TLS) based on your security requirements.
- Enable monitoring and logging for better observability and troubleshooting.

## Troubleshooting

### Reporting Issues

If you encounter a bug or issue, please report it on the [GitHub repository](https://github.com/sourcefuse/terraform-aws-arc-msk/issues).

## Security Considerations

### AWS VPC

Understand the security considerations related to MSK on AWS when using this module:
- MSK clusters should be deployed in private subnets with appropriate security groups.
- Use encryption in transit and at rest for sensitive data.
- Implement proper authentication mechanisms (SASL/SCRAM, IAM, TLS).

### Best Practices for AWS MSK

Follow best practices to ensure secure MSK configurations:

- [AWS MSK Security Best Practices](https://docs.aws.amazon.com/msk/latest/developerguide/security-best-practices.html)
- Enable encryption in transit and at rest
- Use IAM authentication or SASL/SCRAM for client authentication
- Implement proper network isolation using security groups
- Regularly update Kafka versions to benefit from security patches

## Contributing and Community Support

### Contributing Guidelines

Contribute to the module by following the guidelines outlined in the [CONTRIBUTING.md](https://github.com/sourcefuse/terraform-aws-arc-msk/blob/main/CONTRIBUTING.md) file.

### Reporting Bugs and Issues

If you find a bug or issue, report it on the [GitHub repository](https://github.com/sourcefuse/terraform-aws-arc-msk/issues).

## License

### License Information

This module is licensed under the Apache 2.0 license. Refer to the [LICENSE](https://github.com/sourcefuse/terraform-aws-arc-msk/blob/main/LICENSE) file for more details.

### Open Source Contribution

Contribute to open source by using and enhancing this module. Your contributions are welcome!
