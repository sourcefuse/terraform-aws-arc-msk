################################################################################
## IAM Policy
################################################################################
resource "aws_iam_policy" "msk_connect_policy" {
  name        = "MSKConnectPolicy"
  description = "IAM policy for MSK Connect"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      # Kafka Connect: cluster-wide access for bootstrap and group mgmt
      {
        Effect = "Allow",
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeCluster",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:GetBootstrapBrokers",
          "kafka-cluster:ReadData",
          "kafka-cluster:WriteData",
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:CreateTopic"
        ],
        Resource = "*"
      },

      # Explicit access to specific cluster and topics (may be required for full control)
      {
        Effect = "Allow",
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeCluster",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:GetBootstrapBrokers",
          "kafka-cluster:ReadData",
          "kafka-cluster:WriteData",
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:CreateTopic"
        ],
        Resource = [
          module.msk.cluster_arn,
          "arn:aws:kafka:us-east-1:${data.aws_caller_identity.current.id}:topic/*"
        ]
      },

      # S3 access (for connector JAR/plugin)
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          module.s3.bucket_arn,
          "${module.s3.bucket_arn}/*",

        ]
      },

      # CloudWatch Logs for monitoring/debugging
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}
