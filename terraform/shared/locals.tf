locals {
  common_tags = merge({ Environment = var.environment, ManagedBy = "Terraform" }, var.tags)
  azs         = ["${var.region}a", "${var.region}b", "${var.region}c"]
}
