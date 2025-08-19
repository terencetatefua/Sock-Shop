############################################
# VPC / Networking
############################################

output "vpc_id" {
  value       = module.shared.vpc_id
  description = "VPC ID created by shared module"
}

output "efs_id" {
  value       = module.shared.efs_id
  description = "EFS file system ID"
}

############################################
# EKS
############################################

output "eks_cluster_name" {
  value       = module.shared.eks_cluster_name
  description = "EKS cluster name"
}

############################################
# RDS
############################################

output "rds_endpoint" {
  value       = module.shared.rds_endpoint
  description = "RDS DB endpoint"
}

