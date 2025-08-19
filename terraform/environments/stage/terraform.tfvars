region             = "us-east-2"
environment        = "stage"
eks_cluster_name   = "sockshop-prod"
node_instance_type = "m5.large"
# kubeconfig_path    = "/home/ubuntu/.kube/config"

tags = { Project = "SockShop", Owner = "Platform" }

expose_zipkin              = false
enable_specific_nodeports  = false

enable_rds = true  # typical for prod (Aurora)

aws_account_id = "975050147953" #imput your own AWS Account ID
