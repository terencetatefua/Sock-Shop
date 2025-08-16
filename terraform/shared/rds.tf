# Optional Aurora (toggle with enable_rds)
module "rds" {
  count   = var.enable_rds ? 1 : 0
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.13.1"

  name           = "sockshop-aurora-${var.environment}"
  engine         = "aurora-mysql" # or aurora-postgresql
  engine_mode    = "provisioned"
  engine_version = "8.0.mysql_aurora.3.05.2"

  vpc_id                  = module.vpc.vpc_id
  subnets                 = module.vpc.private_subnets
  create_db_subnet_group  = true

  instance_class          = "db.r6g.large"
  instances               = { one = {} }
  apply_immediately       = true
  monitoring_interval     = 30

  storage_encrypted = true
  kms_key_id        = aws_kms_key.efs.arn # reuse EFS KMS or create separate

  create_security_group = true
  security_group_rules = {
    ingress = {
      type                     = "ingress"
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      source_security_group_id = module.eks.node_security_group_id
    }
  }

  tags = local.common_tags
}
