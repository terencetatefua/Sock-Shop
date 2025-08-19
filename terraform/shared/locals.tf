locals {
  # Common tags
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
  # Default enables ENIConfig usage; users extend/override with var.vpc_cni_env
  ############################################################
  vpc_cni_env = merge(
    { AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true" },
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

  # Base add-ons (we manage all via aws_eks_addon; EKS module is disabled)
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
}
