################################################################################
## IAM Policy
###############################################################################
resource "aws_iam_policy" "msk_source_destination_policy" {
  name        = "${var.environment}_msk_rds_s3_policy"
  description = "IAM policy for MSK Connect source connector"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      # Allow connector to connect to and describe the MSK cluster
      {
        Effect = "Allow",
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeCluster"
        ],
        Resource = module.msk.cluster_arn
      },

      # Read and describe the topic
      {
        Effect = "Allow",
        Action = [
          "kafka-cluster:ReadData",
          "kafka-cluster:DescribeTopic"
        ],
        Resource = [
          "arn:aws:kafka:${var.region}:${data.aws_caller_identity.current.id}:topic/*",
          module.msk.cluster_arn
        ]
      },

      # Allow consumer group operations (needed for tracking offset)
      {
        Effect = "Allow",
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup"
        ],
        Resource = ["arn:aws:kafka:${var.region}:${data.aws_caller_identity.current.id}:group/*",
          module.msk.cluster_arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = [
          module.s3.bucket_arn,
          "${module.s3.bucket_arn}/*"
        ]
      }
    ]
  })
}
