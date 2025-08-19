############################################
# Core inputs
############################################
variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "node_instance_type" {
  type = string
}

# Used by wait_for_cluster + kubectl applies
variable "kubeconfig_path" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

############################################
# Feature toggles
############################################
variable "expose_zipkin" {
  type    = bool
  default = false
}

variable "enable_specific_nodeports" {
  type    = bool
  default = false
}

variable "enable_rds" {
  type    = bool
  default = false
}

############################################
# API access (bootstrap reachability)
############################################
variable "api_allowed_cidrs" {
  description = "CIDR allowlist for EKS public API; tighten after bootstrap."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

############################################
# Managed EKS add-ons toggles
############################################
variable "enable_vpc_cni" {
  type    = bool
  default = true
}

variable "enable_coredns" {
  type    = bool
  default = true
}

variable "enable_kube_proxy" {
  type    = bool
  default = true
}

variable "enable_efs_csi" {
  type    = bool
  default = true
}

variable "enable_ebs_csi" {
  type    = bool
  default = false
}

variable "enable_snapshot_controller" {
  type    = bool
  default = true
}

variable "enable_pod_identity_agent" {
  type    = bool
  default = true
}

variable "enable_fsx_csi" {
  type    = bool
  default = false
}

variable "enable_mountpoint_s3_csi" {
  type    = bool
  default = false
}

############################################
# Optional IRSA role ARNs for add-ons
############################################
variable "irsa_role_arn_vpc_cni" {
  type     = string
  default  = null
  nullable = true
}

variable "irsa_role_arn_efs_csi" {
  type     = string
  default  = null
  nullable = true
}

variable "irsa_role_arn_ebs_csi" {
  type     = string
  default  = null
  nullable = true
}

variable "irsa_role_arn_fsx_csi" {
  type     = string
  default  = null
  nullable = true
}

variable "irsa_role_arn_mountpoint_s3" {
  type     = string
  default  = null
  nullable = true
}

############################################
# VPC CNI env (custom networking defaults + overrides)
############################################
variable "vpc_cni_env" {
  description = "Environment variables for the VPC CNI managed add-on."
  type        = map(string)
  default = {
    AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
    ENI_CONFIG_LABEL_DEF               = "topology.kubernetes.io/zone"
    ENABLE_PREFIX_DELEGATION           = "true"
    WARM_ENI_TARGET                    = "1"
    MINIMUM_IP_TARGET                  = "10"
  }
}

# Optional raw override if you ever want to pass full configuration_values JSON
variable "vpc_cni_config" {
  description = "Optional VPC CNI configuration object; if set, child module will jsonencode({ env = merge(default, vpc_cni_env) }) unless you override."
  type        = any
  default     = null
}

############################################
# Add-on overrides / escape hatch
############################################
variable "cluster_addons_extra" {
  description = "Extra or overriding add-ons to merge into the final cluster_addons map."
  type        = map(any)
  default     = {}
}

############################################
# OPTIONAL: CNI custom networking (ENIConfig)
############################################
variable "pod_subnet_ids_by_az" {
  description = "AZ => subnet ID map for ENIConfig (e.g., { \"us-east-2a\" = \"subnet-abc\" }). Leave empty to skip."
  type        = map(string)
  default     = {}
}

variable "pod_eni_security_group_id" {
  description = "Security Group ID for pod ENIs in ENIConfig. Leave empty to skip."
  type        = string
  default     = ""
}


