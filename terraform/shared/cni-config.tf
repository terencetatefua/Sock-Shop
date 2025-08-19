########################################
# VPC CNI Add-on (managed separately; EKS picks version)
########################################
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = module.eks.cluster_name
  addon_name   = "vpc-cni"

  # No addon_version → EKS chooses a compatible version
  configuration_values     = try(local.cluster_addons_final["vpc-cni"].configuration_values, null)
  service_account_role_arn = try(local.cluster_addons_final["vpc-cni"].service_account_role_arn, null)

  resolve_conflicts_on_create = try(local.cluster_addons_final["vpc-cni"].resolve_conflicts_on_create, "OVERWRITE")
  resolve_conflicts_on_update = try(local.cluster_addons_final["vpc-cni"].resolve_conflicts_on_update, "OVERWRITE")

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [configuration_values]
  }

  # Reuse the wait_gate defined in addons.tf
  depends_on = [null_resource.wait_gate]
}
