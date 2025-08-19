resource "aws_efs_file_system" "main" {
  creation_token   = "sockshop-efs-${var.environment}"
  encrypted        = true
  kms_key_id       = aws_kms_key.efs.arn
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  tags             = merge(local.common_tags, { Name = "sockshop-efs-${var.environment}" })
}

resource "aws_security_group" "efs" {
  name        = "sockshop-efs-sg-${var.environment}"
  description = "Allow NFS from EKS nodes"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "NFS from nodes"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# Use static keys (AZ names) with apply-time values (subnet IDs)
locals {
  efs_mt_map = {
    for idx, az in local.azs : az => {
      subnet_id = module.vpc.private_subnets[idx]
    }
  }
}

resource "aws_efs_mount_target" "private" {
  for_each        = local.efs_mt_map
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = each.value.subnet_id
  security_groups = [aws_security_group.efs.id]
}