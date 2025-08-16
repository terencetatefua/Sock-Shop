# Generate ENIConfig YAML per AZ and apply with kubectl

locals {
  eni_configs = {
    for idx, az in local.azs : az => {
      subnet          = element(module.vpc.private_subnets, idx)
      security_groups = [module.eks.node_security_group_id]
    }
  }

  # Pre-render YAML content so we can hash it (no file reads during plan)
  eni_yaml = {
    for az, v in local.eni_configs : az => yamlencode({
      apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
      kind       = "ENIConfig"
      metadata   = { name = az }
      spec       = {
        subnet         = v.subnet
        securityGroups = v.security_groups
      }
    })
  }
}

# Ensure ./generated exists before writing files (works in Git Bash/mac/Linux)
resource "null_resource" "eni_dir" {
  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/generated"
  }
}

resource "local_file" "eni_config_yaml" {
  for_each = local.eni_yaml

  filename = "${path.module}/generated/eni-config-${each.key}.yaml"
  content  = each.value

  depends_on = [null_resource.eni_dir]
}

resource "null_resource" "apply_eni_config" {
  for_each = local_file.eni_config_yaml

  provisioner "local-exec" {
    command = "kubectl apply -f ${each.value.filename}"
    environment = {
      KUBECONFIG = var.kubeconfig_path
    }
  }

  # Use content hash (not filesha1) to avoid reading files during plan
  triggers = {
    content_hash = sha1(local.eni_yaml[each.key])
  }
}
