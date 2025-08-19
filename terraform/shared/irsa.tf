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

############################################
# IRSA roles for managed add-ons
############################################

# Trust policy for IRSA with this cluster
data "aws_iam_policy_document" "irsa_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn] # from the EKS module output
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# ---------------- VPC CNI (aws-node) ----------------
# AWS managed policy for CNI
data "aws_iam_policy" "cni_managed" {
  arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role" "irsa_vpc_cni" {
  name               = "${var.eks_cluster_name}-irsa-vpc-cni"
  assume_role_policy = data.aws_iam_policy_document.irsa_trust.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "irsa_vpc_cni_attach" {
  role       = aws_iam_role.irsa_vpc_cni.name
  policy_arn = data.aws_iam_policy.cni_managed.arn
}

# ---------------- EFS CSI (efs-csi-controller-sa) ----------------
data "aws_iam_policy" "efs_csi_managed" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}

resource "aws_iam_role" "irsa_efs_csi" {
  name               = "${var.eks_cluster_name}-irsa-efs-csi"
  assume_role_policy = data.aws_iam_policy_document.irsa_trust.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "irsa_efs_csi_attach" {
  role       = aws_iam_role.irsa_efs_csi.name
  policy_arn = data.aws_iam_policy.efs_csi_managed.arn
}

# ---------------- EBS CSI (ebs-csi-controller-sa) ----------------
data "aws_iam_policy" "ebs_csi_managed" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role" "irsa_ebs_csi" {
  count              = var.enable_ebs_csi ? 1 : 0
  name               = "${var.eks_cluster_name}-irsa-ebs-csi"
  assume_role_policy = data.aws_iam_policy_document.irsa_trust.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "irsa_ebs_csi_attach" {
  count      = var.enable_ebs_csi ? 1 : 0
  role       = aws_iam_role.irsa_ebs_csi[0].name
  policy_arn = data.aws_iam_policy.ebs_csi_managed.arn
}


