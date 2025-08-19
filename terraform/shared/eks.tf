#########################################
# EKS Cluster (module does NOT create addons)
#########################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.20"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.environment == "prod" ? "1.31" : "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = var.api_allowed_cidrs

  authentication_mode = "API_AND_CONFIG_MAP"

  eks_managed_node_groups = {
    ng = {
      instance_types = [var.node_instance_type]
      desired_size   = 3
      min_size       = 2
      max_size       = 6
      subnet_ids     = module.vpc.private_subnets
      tags           = var.tags
    }
  }

  # We manage all addons via aws_eks_addon resources (vpc-cni + others)
  cluster_addons = {}

  tags = var.tags
}

#########################################
# Caller identity for trust + access
#########################################

data "aws_caller_identity" "current" {}

#########################################
# IAM Role: eks-admin (no hardcoded account id)
#########################################

data "aws_iam_policy_document" "eks_admin_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_admin" {
  name               = "eks-admin"
  assume_role_policy = data.aws_iam_policy_document.eks_admin_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_admin_attach" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#########################################
# EKS Access for eks-admin Role
#########################################

resource "aws_eks_access_entry" "tf_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.eks_admin.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "tf_admin_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.tf_admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.tf_admin]
}

#########################################
# EKS Access for Current Terraform User/Role
#########################################

resource "aws_eks_access_entry" "current_user" {
  cluster_name  = module.eks.cluster_name
  principal_arn = data.aws_caller_identity.current.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "current_user_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.current_user.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.current_user]
}
