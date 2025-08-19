module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "sockshop-vpc-${var.environment}"
  cidr = "10.0.0.0/16"

  azs             = local.azs
  private_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24","10.0.102.0/24","10.0.103.0/24"]

  enable_nat_gateway           = true
  single_nat_gateway           = true
  enable_dns_hostnames         = true
  enable_dns_support           = true
  manage_default_route_table   = true
  map_public_ip_on_launch      = false

  # Secondary CIDR (for custom pod ENIs if needed)
  secondary_cidr_blocks = ["100.64.0.0/16"]

  tags = local.common_tags
}