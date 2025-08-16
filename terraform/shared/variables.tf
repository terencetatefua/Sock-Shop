variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "node_instance_type" {
  type = string
}

variable "kubeconfig_path" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

# Security toggles
variable "expose_zipkin" {
  type    = bool
  default = false
}

variable "enable_specific_nodeports" {
  type    = bool
  default = false
}

# DB toggles
variable "enable_rds" {
  type    = bool
  default = false
}
