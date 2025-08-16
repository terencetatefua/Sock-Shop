# IAM policy we attach to the IRSA role (unchanged)
data "aws_iam_policy_document" "secretsmanager_read" {
  statement {
    sid       = "SecretsManagerRead"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "secretsmanager_read" {
  name        = "irsa-secretsmanager-read-${var.environment}"
  description = "Allow pods to read secrets from AWS Secrets Manager"
  policy      = data.aws_iam_policy_document.secretsmanager_read.json
  tags        = local.common_tags
}

# ✅ FIX: map(string) for role_policy_arns
module "irsa_secrets_manager" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.39.1"

  role_name = "irsa-secretsmanager-${var.environment}"

  role_policy_arns = {
    secrets_read = aws_iam_policy.secretsmanager_read.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["sock-shop:default"]
    }
  }

  tags = local.common_tags
}
