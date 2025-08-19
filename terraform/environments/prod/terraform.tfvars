region             = "us-east-2"
environment        = "prod"
eks_cluster_name   = "sockshop-prod"
node_instance_type = "m5.large"
kubeconfig_path    = "C:\\Users\\mispa\\.kube\\config"

tags = { Project = "SockShop", Owner = "Platform" }

expose_zipkin             = false
enable_specific_nodeports = false

