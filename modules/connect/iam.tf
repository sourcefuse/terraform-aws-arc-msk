#########################################################
# MSK Service Role
##########################################################
resource "aws_iam_role" "msk_connector_service_role" {
  count = var.create_connector ? 1 : 0
  name  = "${var.connector_name}-MSKConnectorServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "kafkaconnect.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "msk_connector_policy_attachments" {
  for_each   = var.msk_connector_policy_arns
  role       = aws_iam_role.msk_connector_service_role[0].name
  policy_arn = each.value
}
