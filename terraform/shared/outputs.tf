############################################
# VPC
############################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

############################################
# EKS
############################################

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

############################################
# EFS
############################################

output "efs_id" {
  value = aws_efs_file_system.main.id
}

############################################
# Security Groups
############################################

output "lb_sg_id" {
  value = aws_security_group.lb_public.id
}

############################################
# Aurora – only when enable_rds = true
############################################

output "rds_endpoint" {
  value       = var.enable_rds ? module.rds[0].cluster_endpoint : null
  description = "Aurora writer endpoint (null if enable_rds=false)"
}

output "rds_reader_endpoint" {
  value       = var.enable_rds ? module.rds[0].cluster_reader_endpoint : null
  description = "Aurora reader endpoint (null if enable_rds=false)"
}

############################################
# IRSA Roles (emit variables only to avoid referencing undeclared resources)
############################################

output "irsa_role_arn_vpc_cni" {
  value       = var.irsa_role_arn_vpc_cni
  description = "IAM role ARN used by the VPC CNI add-on (if provided)."
}

output "irsa_role_arn_efs_csi" {
  value       = var.irsa_role_arn_efs_csi
  description = "IAM role ARN used by the EFS CSI add-on (if provided)."
}

output "irsa_role_arn_ebs_csi" {
  value       = var.irsa_role_arn_ebs_csi
  description = "IAM role ARN used by the EBS CSI add-on (if provided)."
}

############################################
# Raw EKS Module (if needed for advanced use)
############################################

output "eks_module" {
  value = module.eks
}
