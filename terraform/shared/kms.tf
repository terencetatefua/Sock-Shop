resource "aws_kms_key" "efs" {
  description             = "KMS key for EFS encryption (${var.environment})"
  enable_key_rotation     = true
  deletion_window_in_days = 7
  tags = local.common_tags
}
