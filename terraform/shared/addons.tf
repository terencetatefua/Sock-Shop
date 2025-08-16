##############################
# EFS CSI Driver (Helm)
##############################
resource "helm_release" "aws_efs_csi_driver" {
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"
  version    = "2.6.7"

  # Use 'set' as an argument (list of maps), not blocks
  set = [
    { name = "controller.serviceAccount.create", value = "true" }
  ]
}

#########################################
# AWS Load Balancer Controller (Helm)
#########################################
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  # Required config
  set = [
    { name = "clusterName",           value = module.eks.cluster_name },
    { name = "region",                value = var.region },
    { name = "vpcId",                 value = module.vpc.vpc_id },
    { name = "serviceAccount.create", value = "true" }
  ]

  # If you later add an IRSA role for ALB Controller, annotate the SA like this:
  # set = concat(
  #   [
  #     { name = "clusterName", value = module.eks.cluster_name },
  #     { name = "region",      value = var.region },
  #     { name = "vpcId",       value = module.vpc.vpc_id },
  #     { name = "serviceAccount.create", value = "true" }
  #   ],
  #   [
  #     {
  #       name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
  #       value = module.alb_irsa.iam_role_arn  # <- your IRSA role output
  #     }
  #   ]
  # )
}
