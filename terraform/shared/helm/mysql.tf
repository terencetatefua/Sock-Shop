# Catalogue DB via Helm (use enable_rds=true to swap to Aurora instead)
resource "helm_release" "catalogue_db" {
  count      = var.enable_rds ? 0 : 1
  name       = "catalogue-db"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mysql"
  namespace  = "sock-shop"

  values = [file("${path.module}/values/catalogue-db.yaml")]

  set { name = "auth.username"; value = local.mysql_catalogue_db.username }
  set { name = "auth.password"; value = local.mysql_catalogue_db.password }
  set { name = "auth.database"; value = "catalogue" }
}
