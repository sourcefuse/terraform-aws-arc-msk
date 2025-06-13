################################################################################
## IAM Policy
###############################################################################
resource "aws_iam_policy" "msk_source_destination_policy" {
  name        = "${var.environment}-${var.namespace}-msk-rds-s3-policy"
  description = "IAM policy for MSK Connect source connector"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      # Allow connector to connect to and describe the MSK cluster
      {
        "Effect" : "Allow",
        "Action" : [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeCluster",
          "kafka-cluster:ReadData",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:WriteData",
          "kafka-cluster:CreateTopic",
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup"
        ],
        "Resource" : "*"
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
