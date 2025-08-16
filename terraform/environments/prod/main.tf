module "shared" {
  source = "../../shared"

  region                    = var.region
  environment               = var.environment
  eks_cluster_name          = var.eks_cluster_name
  node_instance_type        = var.node_instance_type
  kubeconfig_path           = var.kubeconfig_path
  tags                      = var.tags
  expose_zipkin             = var.expose_zipkin
  enable_specific_nodeports = var.enable_specific_nodeports
  enable_rds                = var.enable_rds
}
