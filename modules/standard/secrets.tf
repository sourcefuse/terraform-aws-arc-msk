#####################################
# KMS Key for SCRAM Secret Encryption
#####################################
resource "aws_kms_key" "scram" {
  count       = local.scram_enabled ? 1 : 0
  description = "${var.cluster_name} KMS key for MSK SCRAM secret encryption"
  tags        = var.tags
}

###################################
# Secrets Manager Secret for SCRAM
###################################
resource "random_id" "scram_suffix" {
  count       = local.scram_enabled ? 1 : 0
  byte_length = 4
}

resource "aws_secretsmanager_secret" "scram" {
  count                          = local.scram_enabled ? 1 : 0
  name                           = "AmazonMSK_${var.cluster_name}_scram_${random_id.scram_suffix[count.index].id}"
  kms_key_id                     = aws_kms_key.scram[0].key_id
  recovery_window_in_days        = 7
  force_overwrite_replica_secret = true
  tags                           = var.tags
}

##########################################
# Secrets Manager Secret Version for SCRAM
##########################################
resource "aws_secretsmanager_secret_version" "scram" {
  count     = local.scram_enabled ? 1 : 0
  secret_id = aws_secretsmanager_secret.scram[0].id
  secret_string = jsonencode({
    username = local.scram_username
    password = local.scram_password
  })
}

# IAM Policy Document for SCRAM Access
data "aws_iam_policy_document" "scram" {
  count = local.scram_enabled ? 1 : 0

  statement {
    sid    = "AWSKafkaResourcePolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["kafka.amazonaws.com"]
    }

    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.scram[0].arn]
  }
}

# Secret Policy for SCRAM Authentication
resource "aws_secretsmanager_secret_policy" "scram" {
  count      = local.scram_enabled ? 1 : 0
  secret_arn = aws_secretsmanager_secret.scram[0].arn
  policy     = data.aws_iam_policy_document.scram[0].json
}

###############################
# MSK SCRAM Secret Association
###############################

resource "aws_msk_scram_secret_association" "scram" {
  count           = local.scram_enabled ? 1 : 0
  cluster_arn     = aws_msk_cluster.this.arn
  secret_arn_list = [aws_secretsmanager_secret.scram[0].arn]

  depends_on = [aws_secretsmanager_secret_version.scram]
}

################################################################
# Random Username and Password Generation for SCRAM (Optional)
################################################################

resource "random_pet" "scram_username" {
  count  = local.scram_enabled && (var.scram_username == null || var.scram_username == "") ? 1 : 0
  length = 2
}

resource "random_password" "scram_password" {
  count   = local.scram_enabled && (var.scram_password == null || var.scram_password == "") ? 1 : 0
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}
