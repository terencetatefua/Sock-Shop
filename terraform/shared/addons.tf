##############################
# EFS CSI Driver (Helm)
##############################
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

  depends_on = [module.eks]
}

#########################################
# AWS Load Balancer Controller (Helm)
#########################################
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  # Values via repeated 'set' blocks
  set {
    name  = "clusterName"
    value = tostring(module.eks.cluster_name)
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = tostring(module.vpc.vpc_id)
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  depends_on = [module.eks]
}
