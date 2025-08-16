# EFS CSI driver (as Helm) – works well with EKS >=1.24
resource "helm_release" "aws_efs_csi_driver" {
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"
  version    = "2.6.7"

  set {
    name  = "controller.serviceAccount.create"
    value = "true"
  }
}

# (Optional but recommended) AWS Load Balancer Controller
# Requires: OIDC + IAM role; using Helm defaults when cluster has OIDC.
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  set {
    name  = "region"
    value = var.region
  }
  # If you want to bind a specific SG to the ALB, set via Ingress annotation later.
}
