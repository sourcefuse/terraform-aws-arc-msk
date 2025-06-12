################################################
## imports
################################################
## vpc
data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-vpc"]
  }
}

# network
data "aws_subnets" "public" {
  filter {
    name = "tag:Name"
    values = [
      "${var.namespace}-${var.environment}-public-subnet-public-${var.region}a",
      "${var.namespace}-${var.environment}-public-subnet-public-${var.region}b"
    ]
  }
}


data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "db_password" {
  name = "/${var.namespace}/${var.environment}/aurora/cluster_admin_db_password"
}

data "aws_ssm_parameter" "db_username" {
  name = "/${var.namespace}/${var.environment}/aurora/cluster_admin_db_username"
}

data "aws_ssm_parameter" "db_endpoint" {
  name = "/${var.namespace}/${var.environment}/aurora/cluster_endpoint"
}
