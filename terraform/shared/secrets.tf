# --------------------------------------------------------------------
# 🔐 Read-only: All secrets are created manually in AWS Secrets Manager
# --------------------------------------------------------------------

# MongoDB secrets
data "aws_secretsmanager_secret_version" "mongo_user_db" {
  secret_id = "sockshop/mongodb/user-db"
}

data "aws_secretsmanager_secret_version" "mongo_orders_db" {
  secret_id = "sockshop/mongodb/orders-db"
}

data "aws_secretsmanager_secret_version" "mongo_carts_db" {
  secret_id = "sockshop/mongodb/carts-db"
}

# MySQL catalogue-db secret
data "aws_secretsmanager_secret_version" "mysql_catalogue_db" {
  secret_id = "sockshop/mysql/catalogue-db"
}

# Aurora RDS master credentials
# Read only when we actually intend to create RDS (enable_rds_effective)
data "aws_secretsmanager_secret_version" "rds_master" {
  count = local.enable_rds_effective ? 1 : 0

  # If you add var.rds_master_secret_arn, prefer it; else default name
  secret_id = var.rds_master_secret_arn != "" ? var.rds_master_secret_arn : "sockshop/rds/master"
}

# --------------------------------------------------------------------
# 🔐 Local objects (JSON-decoded values)
# --------------------------------------------------------------------

locals {
  mongo_user_db      = jsondecode(data.aws_secretsmanager_secret_version.mongo_user_db.secret_string)
  mongo_orders_db    = jsondecode(data.aws_secretsmanager_secret_version.mongo_orders_db.secret_string)
  mongo_carts_db     = jsondecode(data.aws_secretsmanager_secret_version.mongo_carts_db.secret_string)
  mysql_catalogue_db = jsondecode(data.aws_secretsmanager_secret_version.mysql_catalogue_db.secret_string)

  # ✅ Keep the ternary on one line to avoid parser errors
  rds_master_db = local.enable_rds_effective ? jsondecode(data.aws_secretsmanager_secret_version.rds_master[0].secret_string) : null
}
