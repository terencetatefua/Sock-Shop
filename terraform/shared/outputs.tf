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
# IRSA Roles (prefer variables; fall back if resources exist)
############################################

output "irsa_role_arn_vpc_cni" {
  value       = try(aws_iam_role.irsa_vpc_cni.arn, var.irsa_role_arn_vpc_cni)
  description = "IAM role ARN used by the VPC CNI add-on (variable or created resource)."
}

output "irsa_role_arn_efs_csi" {
  value       = try(aws_iam_role.irsa_efs_csi.arn, var.irsa_role_arn_efs_csi)
  description = "IAM role ARN used by the EFS CSI add-on (variable or created resource)."
}

output "irsa_role_arn_ebs_csi" {
  value       = try(aws_iam_role.irsa_ebs_csi[0].arn, var.irsa_role_arn_ebs_csi)
  description = "IAM role ARN used by the EBS CSI add-on (variable or created resource)."
}


############################################
# Raw EKS Module (if needed for advanced use)
############################################

output "eks_module" {
  value = module.eks
}
