############################################################
# Aurora creation switch (robust)
# - Create when enable_rds=true OR env is stage/prod
############################################################
locals {
  enable_rds_effective = var.enable_rds || contains(["stage", "prod"], lower(var.environment))

  # Use provided KMS key if passed; else AWS-managed RDS key (null)
  rds_kms_key_id = var.rds_kms_key_arn != "" ? var.rds_kms_key_arn : null
}

# Optional: small debug to prove the flag in plan (safe to keep or remove)
resource "null_resource" "rds_debug" {
  count = local.enable_rds_effective ? 1 : 0
  triggers = {
    effective = tostring(local.enable_rds_effective)
  }
}

############################################################
# Aurora (RDS) – created only when enable_rds_effective is true
############################################################
module "rds" {
  count   = local.enable_rds_effective ? 1 : 0
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
  kms_key_id        = local.rds_kms_key_id   # null → AWS-managed key

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

  # Credentials from secrets.tf (safe: only non-null when creating)
  master_username = local.rds_master_db != null ? local.rds_master_db.username : null
  master_password = local.rds_master_db != null ? local.rds_master_db.password : null

  tags = local.common_tags
}
