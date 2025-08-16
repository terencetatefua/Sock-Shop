# Read-only: all secrets are created manually in AWS Secrets Manager

# MongoDB creds
data "aws_secretsmanager_secret_version" "mongo_user_db" {
  secret_id = "sockshop/mongodb/user-db"
}
data "aws_secretsmanager_secret_version" "mongo_orders_db" {
  secret_id = "sockshop/mongodb/orders-db"
}
data "aws_secretsmanager_secret_version" "mongo_carts_db" {
  secret_id = "sockshop/mongodb/carts-db"
}

# MySQL creds (catalogue-db)
data "aws_secretsmanager_secret_version" "mysql_catalogue_db" {
  secret_id = "sockshop/mysql/catalogue-db"
}

locals {
  mongo_user_db      = jsondecode(data.aws_secretsmanager_secret_version.mongo_user_db.secret_string)
  mongo_orders_db    = jsondecode(data.aws_secretsmanager_secret_version.mongo_orders_db.secret_string)
  mongo_carts_db     = jsondecode(data.aws_secretsmanager_secret_version.mongo_carts_db.secret_string)
  mysql_catalogue_db = jsondecode(data.aws_secretsmanager_secret_version.mysql_catalogue_db.secret_string)
}
