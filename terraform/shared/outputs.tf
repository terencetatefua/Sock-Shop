# VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

# EKS
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

# EFS
output "efs_id" {
  value = aws_efs_file_system.main.id
}

# Security groups
output "lb_sg_id" {
  value = aws_security_group.lb_public.id
}

###############################################
# RDS / Aurora (only when enable_rds = true)
###############################################
# Writer endpoint (Aurora cluster endpoint)
output "rds_endpoint" {
  value       = var.enable_rds ? module.rds[0].cluster_endpoint : null
  description = "Aurora writer endpoint (null if enable_rds=false)"
}

# Reader endpoint (Aurora read-only endpoint)
output "rds_reader_endpoint" {
  value       = var.enable_rds ? module.rds[0].reader_endpoint : null
  description = "Aurora reader endpoint (null if enable_rds=false)"
}
