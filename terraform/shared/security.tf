########################################
# Public Load Balancer Security Group
########################################
resource "aws_security_group" "lb_public" {
  name        = "sockshop-alb-${var.environment}"
  description = "Public ALB SG for SockShop"
  vpc_id      = module.vpc.vpc_id
  tags        = merge(local.common_tags, { Name = "sockshop-alb-${var.environment}" })
}

resource "aws_security_group_rule" "lb_ingress_http" {
  type              = "ingress"
  security_group_id = aws_security_group.lb_public.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "HTTP"
}

resource "aws_security_group_rule" "lb_ingress_https" {
  type              = "ingress"
  security_group_id = aws_security_group.lb_public.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "HTTPS"
}

resource "aws_security_group_rule" "lb_ingress_zipkin" {
  count             = var.expose_zipkin ? 1 : 0
  type              = "ingress"
  security_group_id = aws_security_group.lb_public.id
  from_port         = 9411
  to_port           = 9411
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Zipkin (optional)"
}

resource "aws_security_group_rule" "lb_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.lb_public.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "ALB egress"
}

###########################################################
# Allow ALB -> NodePorts on EKS nodes (instance target)
###########################################################
resource "aws_security_group_rule" "nodes_nodeport_from_lb" {
  type                     = "ingress"
  security_group_id        = module.eks.node_security_group_id
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_public.id
  description              = "ALB to NodePort"
}

# Optional precise rules (if you keep fixed NodePorts like 30001/30002/31601)
resource "aws_security_group_rule" "nodes_nodeport_30001_from_lb" {
  count                    = var.enable_specific_nodeports ? 1 : 0
  type                     = "ingress"
  security_group_id        = module.eks.node_security_group_id
  from_port                = 30001
  to_port                  = 30001
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_public.id
}
resource "aws_security_group_rule" "nodes_nodeport_30002_from_lb" {
  count                    = var.enable_specific_nodeports ? 1 : 0
  type                     = "ingress"
  security_group_id        = module.eks.node_security_group_id
  from_port                = 30002
  to_port                  = 30002
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_public.id
}
resource "aws_security_group_rule" "nodes_nodeport_31601_from_lb" {
  count                    = var.enable_specific_nodeports ? 1 : 0
  type                     = "ingress"
  security_group_id        = module.eks.node_security_group_id
  from_port                = 31601
  to_port                  = 31601
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_public.id
}

