# Generate ENIConfig YAML per AZ (to be applied with kubectl)
locals {
  eni_configs = {
    for idx, az in local.azs : az => {
      subnet          = element(module.vpc.private_subnets, idx)
      security_groups = [module.eks.node_security_group_id]
    }
  }
}

resource "local_file" "eni_config_yaml" {
  for_each = local.eni_configs
  filename = "${path.module}/generated/eni-config-${each.key}.yaml"
  content  = yamlencode({
    apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
    kind       = "ENIConfig"
    metadata   = { name = each.key }
    spec       = {
      subnet         = each.value.subnet
      securityGroups = each.value.security_groups
    }
  })
}

resource "null_resource" "apply_eni_config" {
  for_each = local_file.eni_config_yaml

  provisioner "local-exec" {
    command = "kubectl apply -f ${each.value.filename}"
    environment = { KUBECONFIG = var.kubeconfig_path }
  }
  triggers = { filehash = filesha1(each.value.filename) }
}
