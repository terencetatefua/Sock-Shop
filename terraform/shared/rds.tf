module "rds" {
  count   = var.enable_rds ? 1 : 0
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.14.0"

  name           = "sockshop-mysql-${var.environment}"
  engine         = "aurora-mysql"
  engine_mode    = "provisioned"
  engine_version = "8.0.mysql_aurora.3.05.2"

  vpc_id                 = module.vpc.vpc_id
  subnets                = module.vpc.private_subnets
  create_db_subnet_group = true

  instance_class      = "db.r6g.large"
  instances           = { one = {} }
  apply_immediately   = true
  monitoring_interval = 30

  storage_encrypted = true
  kms_key_id        = aws_kms_key.efs.arn

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

  # 🔐 Injected credentials from local decoded secret
  master_username = local.rds_master_db.username
  master_password = local.rds_master_db.password

  tags = local.common_tags
}
