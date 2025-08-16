region             = "us-east-2"
environment        = "dev"
eks_cluster_name   = "sockshop-dev"
node_instance_type = "m3.large"
#kubeconfig_path    = "/home/ubuntu/.kube/config"

tags = { Project = "SockShop" }

# Security toggles
expose_zipkin              = false
enable_specific_nodeports  = false

# DB deployment toggles
enable_rds = false  # set true if you want Aurora instead of Helm MySQL
