resource "aws_kms_key" "msk" {
  count                   = var.create_kms_key ? 1 : 0
  description             = "KMS key for MSK encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = var.tags
}

resource "aws_kms_alias" "msk" {
  count         = var.create_kms_key ? 1 : 0
  name          = "alias/${var.cluster_name}-msk-key"
  target_key_id = aws_kms_key.msk[0].key_id
}
