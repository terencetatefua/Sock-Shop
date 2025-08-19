########################################
# Non-core EKS Add-ons (exclude vpc-cni, coredns, kube-proxy)
########################################
resource "aws_eks_addon" "others" {
  for_each = {
    for k, v in local.cluster_addons_final :
    k => v if !contains(["vpc-cni", "coredns", "kube-proxy"], k)
  }

  cluster_name = module.eks.cluster_name
  addon_name   = each.key

  addon_version            = try(each.value.version, null)
  configuration_values     = try(each.value.configuration_values, null)
  service_account_role_arn = try(each.value.service_account_role_arn, null)

  resolve_conflicts_on_create = try(each.value.resolve_conflicts_on_create, "OVERWRITE")
  resolve_conflicts_on_update = try(each.value.resolve_conflicts_on_update, "OVERWRITE")

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      addon_version,
      configuration_values,
    ]
  }

  depends_on = [null_resource.wait_gate]
}

########################################
# Gate: wait until EKS control plane is ready (no input var required)
########################################
resource "null_resource" "wait_gate" {
  triggers = {
    # changes when control plane endpoint changes; forces re-run of dependents
    endpoint = module.eks.cluster_endpoint
  }

  depends_on = [module.eks]
}
