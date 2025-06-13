#########################################################
# MSK Serverless
##########################################################
resource "aws_msk_serverless_cluster" "this" {
  cluster_name = var.cluster_name

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  client_authentication {
    sasl {
      iam {
        enabled = var.sasl_iam_enabled
      }
    }
  }

  tags = var.tags
}

#########################################################
# MSK Cluster Policy
##########################################################
resource "aws_msk_cluster_policy" "this" {
  count       = var.create_cluster_policy && length(var.policy_statements) > 0 ? 1 : 0
  cluster_arn = aws_msk_serverless_cluster.this.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      for stmt in var.policy_statements : {
        Sid       = stmt.sid
        Effect    = stmt.effect
        Action    = stmt.actions
        Principal = stmt.principal # This can now be any valid IAM principal structure
        Resource  = length(stmt.resources) > 0 ? stmt.resources : [aws_msk_serverless_cluster.this.arn]
      }
    ]
  })
}
