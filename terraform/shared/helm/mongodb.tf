resource "helm_release" "mongo_user_db" {
  name       = "user-db"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  namespace  = "sock-shop"

  values = [file("${path.module}/values/user-db.yaml")]

  set { name = "auth.username"; value = local.mongo_user_db.username }
  set { name = "auth.password"; value = local.mongo_user_db.password }
  set { name = "auth.database"; value = "user" }
}

resource "helm_release" "mongo_orders_db" {
  name       = "orders-db"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  namespace  = "sock-shop"

  values = [file("${path.module}/values/orders-db.yaml")]

  set { name = "auth.username"; value = local.mongo_orders_db.username }
  set { name = "auth.password"; value = local.mongo_orders_db.password }
  set { name = "auth.database"; value = "orders" }
}

resource "helm_release" "mongo_carts_db" {
  name       = "carts-db"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  namespace  = "sock-shop"

  values = [file("${path.module}/values/carts-db.yaml")]

  set { name = "auth.username"; value = local.mongo_carts_db.username }
  set { name = "auth.password"; value = local.mongo_carts_db.password }
  set { name = "auth.database"; value = "carts" }
}
