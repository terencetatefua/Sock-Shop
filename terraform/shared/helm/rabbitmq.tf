resource "helm_release" "rabbitmq" {
  name       = "rabbitmq"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq"
  namespace  = "sock-shop"

  values = [file("${path.module}/values/rabbitmq.yaml")]
}
