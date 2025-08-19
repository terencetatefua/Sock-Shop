locals {
  ############################################################
  # Common tags
  ############################################################
  common_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )

  # Convenience AZ list
  azs = ["${var.region}a", "${var.region}b", "${var.region}c"]

  ############################################################
  # VPC CNI: Custom networking env (default + user overrides)
  # Make sure ENI_CONFIG_LABEL_DEF uses the AZ label
  ############################################################
  vpc_cni_env = merge(
    {
      AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
      ENI_CONFIG_LABEL_DEF               = "topology.kubernetes.io/zone"
    },
    var.vpc_cni_env
  )

  # VPC CNI addon definition (no version specified → EKS picks)
  vpc_cni_addon = {
    "vpc-cni" = merge(
      {
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
        configuration_values        = jsonencode({ env = local.vpc_cni_env })
      },
      var.irsa_role_arn_vpc_cni != null ? {
        service_account_role_arn = var.irsa_role_arn_vpc_cni
      } : {}
    )
  }

  ############################################################
  # Base add-ons (we manage all via aws_eks_addon)
  ############################################################
  _addons_base = merge(
    local.vpc_cni_addon,

    var.enable_efs_csi ? {
      "aws-efs-csi-driver" = merge(
        {
          resolve_conflicts_on_create = "OVERWRITE"
          resolve_conflicts_on_update = "OVERWRITE"
        },
        var.irsa_role_arn_efs_csi != null ? {
          service_account_role_arn = var.irsa_role_arn_efs_csi
        } : {}
      )
    } : {},

    var.enable_ebs_csi ? {
      "aws-ebs-csi-driver" = merge(
        {
          resolve_conflicts_on_create = "OVERWRITE"
          resolve_conflicts_on_update = "OVERWRITE"
        },
        var.irsa_role_arn_ebs_csi != null ? {
          service_account_role_arn = var.irsa_role_arn_ebs_csi
        } : {}
      )
    } : {},

    var.enable_fsx_csi ? {
      "aws-fsx-csi-driver" = merge(
        {
          resolve_conflicts_on_create = "OVERWRITE"
          resolve_conflicts_on_update = "OVERWRITE"
        },
        var.irsa_role_arn_fsx_csi != null ? {
          service_account_role_arn = var.irsa_role_arn_fsx_csi
        } : {}
      )
    } : {},

    var.enable_snapshot_controller ? {
      "snapshot-controller" = {
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
      }
    } : {},

    var.enable_pod_identity_agent ? {
      "eks-pod-identity-agent" = {
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
      }
    } : {},

    var.enable_mountpoint_s3_csi ? {
      "aws-mountpoint-s3-csi-driver" = merge(
        {
          resolve_conflicts_on_create = "OVERWRITE"
          resolve_conflicts_on_update = "OVERWRITE"
        },
        var.irsa_role_arn_mountpoint_s3 != null ? {
          service_account_role_arn = var.irsa_role_arn_mountpoint_s3
        } : {}
      )
    } : {}
  )

  # Final merged add-ons map used by aws_eks_addon resources
  cluster_addons_final = merge(
    local._addons_base,
    var.cluster_addons_extra
  )

  ############################################################
  # ENIConfig: derive values automatically, allow overrides
  ############################################################

  # Auto map AZ -> private subnet (index-aligned outputs from VPC module)
  pod_subnet_ids_by_az_auto = {
    for idx, az in module.vpc.azs :
    az => module.vpc.private_subnets[idx]
  }

  # Effective AZ=>subnet map (override with vars if provided)
  pod_subnet_ids_by_az_effective = (
    length(var.pod_subnet_ids_by_az) > 0
    ? var.pod_subnet_ids_by_az
    : local.pod_subnet_ids_by_az_auto
  )
}

# Create a dedicated SG for pod ENIs unless one is provided
resource "aws_security_group" "pod_eni" {
  count       = var.pod_eni_security_group_id == "" ? 1 : 0
  name        = "sockshop-pod-eni-${var.environment}"
  description = "Security Group for Pod ENIs (VPC CNI custom networking)"
  vpc_id      = module.vpc.vpc_id
  tags        = merge(local.common_tags, { Name = "sockshop-pod-eni-${var.environment}" })
}

# Egress all (pods need outbound)
resource "aws_security_group_rule" "pod_eni_egress_all" {
  count             = var.pod_eni_security_group_id == "" ? 1 : 0
  type              = "egress"
  security_group_id = aws_security_group.pod_eni[0].id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Pod ENI egress"
}

locals {
  # Effective SG id (either provided or created)
  pod_eni_sg_id_effective = var.pod_eni_security_group_id != "" ? var.pod_eni_security_group_id : aws_security_group.pod_eni[0].id

  # ✅ Plan-safe enable flag (doesn't depend on resource attributes)
  _eniconfig_enabled_plan = length(local.pod_subnet_ids_by_az_effective) > 0

  # Multi-doc YAML: one ENIConfig per AZ
  eni_configs_yaml = join("\n---\n", [
    for az, subnet_id in local.pod_subnet_ids_by_az_effective : yamlencode({
      apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
      kind       = "ENIConfig"
      metadata = { name = az }
      spec = {
        securityGroups = [local.pod_eni_sg_id_effective]
        subnet         = subnet_id
      }
    })
  ])

  # Minimal CRD (idempotent)
  eni_crd_yaml = <<-YAML
    apiVersion: apiextensions.k8s.io/v1
    kind: CustomResourceDefinition
    metadata:
      name: eniconfigs.crd.k8s.amazonaws.com
    spec:
      group: crd.k8s.amazonaws.com
      names:
        kind: ENIConfig
        listKind: ENIConfigList
        plural: eniconfigs
        singular: eniconfig
      scope: Cluster
      versions:
        - name: v1alpha1
          served: true
          storage: true
          schema:
            openAPIV3Schema:
              type: object
              x-kubernetes-preserve-unknown-fields: true
  YAML
}

############################################################
# Write the rendered ENIConfig YAML
############################################################
resource "local_file" "eni_configs" {
  count    = local._eniconfig_enabled_plan ? 1 : 0
  filename = "${path.module}/eni-configs.yaml"
  content  = trimspace(local.eni_configs_yaml)
}

############################################################
# Ensure CRD exists (after API is reachable)
############################################################
resource "null_resource" "apply_eniconfig_crd" {
  count = local._eniconfig_enabled_plan ? 1 : 0

  depends_on = [null_resource.wait_gate]

  triggers = {
    crd_sha = sha256(local.eni_crd_yaml)
  }

  provisioner "local-exec" {
    command = <<-EOC
      set -euo pipefail
      CRD_FILE="$(mktemp)"
      cat > "$CRD_FILE" <<'EOF'
      ${trimspace(local.eni_crd_yaml)}
      EOF

      if [ -n "${var.kubeconfig_path}" ]; then
        kubectl --kubeconfig "${var.kubeconfig_path}" apply -f "$CRD_FILE"
      else
        kubectl apply -f "$CRD_FILE"
      fi
    EOC
    interpreter = ["bash", "-lc"]
  }
}

############################################################
# Apply ENIConfigs after control plane + vpc-cni are ready
############################################################
resource "null_resource" "apply_eni_configs" {
  count = local._eniconfig_enabled_plan ? 1 : 0

  depends_on = [
    null_resource.wait_gate, # from addons.tf
    aws_eks_addon.vpc_cni,   # from cni-config.tf
    null_resource.apply_eniconfig_crd
  ]

  triggers = {
    sha = sha256(local_file.eni_configs[0].content)
  }

  provisioner "local-exec" {
    command = <<-EOC
      set -euo pipefail
      if [ -n "${var.kubeconfig_path}" ]; then
        kubectl --kubeconfig "${var.kubeconfig_path}" apply -f "${local_file.eni_configs[0].filename}"
      else
        kubectl apply -f "${local_file.eni_configs[0].filename}"
      fi
    EOC
    interpreter = ["bash", "-lc"]
  }
}
