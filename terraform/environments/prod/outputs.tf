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

output "rds_reader_endpoint" {
  value       = module.shared.rds_reader_endpoint
  description = "Aurora reader endpoint (null if enable_rds=false)"
}

output "shared_enable_rds_effective" {
  value       = module.shared.enable_rds_effective
  description = "Pass-through flag from shared module (debug)."
}
