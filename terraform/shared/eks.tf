module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name                    = var.eks_cluster_name
  cluster_version                 = "1.31"
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  enable_irsa                     = true
  cluster_endpoint_public_access  = true

  eks_managed_node_groups = {
    default = {
      desired_size  = 2
      min_size      = 1
      max_size      = 4
      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND"
    }
  }

  # Core EKS addons
  cluster_addons = {
    coredns   = { most_recent = true }
    kube-proxy= { most_recent = true }
    vpc-cni   = { most_recent = true }
  }

  tags = local.common_tags
}
