## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.13 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.29 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.3 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 20.20 |
| <a name="module_irsa_secrets_manager"></a> [irsa\_secrets\_manager](#module\_irsa\_secrets\_manager) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.39.1 |
| <a name="module_rds"></a> [rds](#module\_rds) | terraform-aws-modules/rds-aurora/aws | 9.14.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.8.1 |

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_eks_access_entry.current_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_entry.tf_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.current_user_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_access_policy_association.tf_admin_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_addon.others](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_iam_policy.secretsmanager_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.irsa_ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.irsa_efs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.irsa_vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_admin_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.irsa_ebs_csi_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.irsa_efs_csi_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.irsa_vpc_cni_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.lb_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.pod_eni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.lb_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.lb_ingress_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.lb_ingress_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.lb_ingress_zipkin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_nodeport_30001_from_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_nodeport_30002_from_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_nodeport_31601_from_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_nodeport_from_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pod_eni_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [kubernetes_storage_class.efs_sc](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [local_file.eni_configs](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.apply_eni_configs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.apply_eniconfig_crd](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.rds_debug](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_gate](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.cni_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.ebs_csi_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.efs_csi_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.eks_admin_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.irsa_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.secretsmanager_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_secretsmanager_secret_version.mongo_carts_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.mongo_orders_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.mongo_user_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.mysql_catalogue_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.rds_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_allowed_cidrs"></a> [api\_allowed\_cidrs](#input\_api\_allowed\_cidrs) | CIDR allowlist for EKS public API; tighten after bootstrap. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_addons_extra"></a> [cluster\_addons\_extra](#input\_cluster\_addons\_extra) | Extra or overriding add-ons merged into the final add-ons map. | `map(any)` | `{}` | no |
| <a name="input_efs_filesystem_id"></a> [efs\_filesystem\_id](#input\_efs\_filesystem\_id) | EFS File System ID for the EFS StorageClass (e.g., fs-0123456789abcdef0). | `string` | `""` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_enable_coredns"></a> [enable\_coredns](#input\_enable\_coredns) | n/a | `bool` | `true` | no |
| <a name="input_enable_ebs_csi"></a> [enable\_ebs\_csi](#input\_enable\_ebs\_csi) | n/a | `bool` | `false` | no |
| <a name="input_enable_efs_csi"></a> [enable\_efs\_csi](#input\_enable\_efs\_csi) | n/a | `bool` | `true` | no |
| <a name="input_enable_fsx_csi"></a> [enable\_fsx\_csi](#input\_enable\_fsx\_csi) | n/a | `bool` | `false` | no |
| <a name="input_enable_kube_proxy"></a> [enable\_kube\_proxy](#input\_enable\_kube\_proxy) | n/a | `bool` | `true` | no |
| <a name="input_enable_mountpoint_s3_csi"></a> [enable\_mountpoint\_s3\_csi](#input\_enable\_mountpoint\_s3\_csi) | n/a | `bool` | `false` | no |
| <a name="input_enable_pod_identity_agent"></a> [enable\_pod\_identity\_agent](#input\_enable\_pod\_identity\_agent) | n/a | `bool` | `true` | no |
| <a name="input_enable_rds"></a> [enable\_rds](#input\_enable\_rds) | n/a | `bool` | `false` | no |
| <a name="input_enable_snapshot_controller"></a> [enable\_snapshot\_controller](#input\_enable\_snapshot\_controller) | n/a | `bool` | `true` | no |
| <a name="input_enable_specific_nodeports"></a> [enable\_specific\_nodeports](#input\_enable\_specific\_nodeports) | n/a | `bool` | `false` | no |
| <a name="input_enable_vpc_cni"></a> [enable\_vpc\_cni](#input\_enable\_vpc\_cni) | ########################################### Managed EKS add-ons (toggles) ########################################### | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_expose_zipkin"></a> [expose\_zipkin](#input\_expose\_zipkin) | ########################################### Feature toggles ########################################### | `bool` | `false` | no |
| <a name="input_irsa_role_arn_ebs_csi"></a> [irsa\_role\_arn\_ebs\_csi](#input\_irsa\_role\_arn\_ebs\_csi) | n/a | `string` | `null` | no |
| <a name="input_irsa_role_arn_efs_csi"></a> [irsa\_role\_arn\_efs\_csi](#input\_irsa\_role\_arn\_efs\_csi) | n/a | `string` | `null` | no |
| <a name="input_irsa_role_arn_fsx_csi"></a> [irsa\_role\_arn\_fsx\_csi](#input\_irsa\_role\_arn\_fsx\_csi) | n/a | `string` | `null` | no |
| <a name="input_irsa_role_arn_mountpoint_s3"></a> [irsa\_role\_arn\_mountpoint\_s3](#input\_irsa\_role\_arn\_mountpoint\_s3) | n/a | `string` | `null` | no |
| <a name="input_irsa_role_arn_vpc_cni"></a> [irsa\_role\_arn\_vpc\_cni](#input\_irsa\_role\_arn\_vpc\_cni) | ########################################### Optional IRSA role ARNs for add-ons ########################################### | `string` | `null` | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to kubeconfig used by null\_resource waits / kubectl | `string` | n/a | yes |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | n/a | `string` | n/a | yes |
| <a name="input_pod_eni_security_group_id"></a> [pod\_eni\_security\_group\_id](#input\_pod\_eni\_security\_group\_id) | Security Group ID for Pod ENIs (ENIConfig). Leave empty to skip. | `string` | `""` | no |
| <a name="input_pod_subnet_ids_by_az"></a> [pod\_subnet\_ids\_by\_az](#input\_pod\_subnet\_ids\_by\_az) | AZ => subnet ID for ENIConfig (e.g., { "us-east-2a" = "subnet-abc" }). | `map(string)` | `{}` | no |
| <a name="input_rds_kms_key_arn"></a> [rds\_kms\_key\_arn](#input\_rds\_kms\_key\_arn) | KMS key ARN for Aurora encryption. Leave empty to use AWS-managed. | `string` | `""` | no |
| <a name="input_rds_master_password"></a> [rds\_master\_password](#input\_rds\_master\_password) | Aurora master password if not using Secrets Manager | `string` | `""` | no |
| <a name="input_rds_master_secret_arn"></a> [rds\_master\_secret\_arn](#input\_rds\_master\_secret\_arn) | Secrets Manager ARN holding {username,password}. If set, overrides the plain vars. | `string` | `""` | no |
| <a name="input_rds_master_username"></a> [rds\_master\_username](#input\_rds\_master\_username) | Aurora master username if not using Secrets Manager | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | ########################################### Core inputs ########################################### | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc_cni_config"></a> [vpc\_cni\_config](#input\_vpc\_cni\_config) | Optional raw config map for the VPC CNI add-on (overrides env if set). | `any` | `null` | no |
| <a name="input_vpc_cni_env"></a> [vpc\_cni\_env](#input\_vpc\_cni\_env) | Environment variables for the VPC CNI add-on (merged with defaults). | `map(string)` | <pre>{<br>  "AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG": "true",<br>  "ENABLE_PREFIX_DELEGATION": "true",<br>  "ENI_CONFIG_LABEL_DEF": "topology.kubernetes.io/zone",<br>  "MINIMUM_IP_TARGET": "10",<br>  "WARM_ENI_TARGET": "1"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | n/a |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | n/a |
| <a name="output_eks_module"></a> [eks\_module](#output\_eks\_module) | n/a |
| <a name="output_enable_rds_effective"></a> [enable\_rds\_effective](#output\_enable\_rds\_effective) | Whether RDS is enabled inside the shared module (computed). |
| <a name="output_irsa_role_arn_ebs_csi"></a> [irsa\_role\_arn\_ebs\_csi](#output\_irsa\_role\_arn\_ebs\_csi) | IAM role ARN used by the EBS CSI add-on (if provided). |
| <a name="output_irsa_role_arn_efs_csi"></a> [irsa\_role\_arn\_efs\_csi](#output\_irsa\_role\_arn\_efs\_csi) | IAM role ARN used by the EFS CSI add-on (if provided). |
| <a name="output_irsa_role_arn_vpc_cni"></a> [irsa\_role\_arn\_vpc\_cni](#output\_irsa\_role\_arn\_vpc\_cni) | IAM role ARN used by the VPC CNI add-on (if provided). |
| <a name="output_lb_sg_id"></a> [lb\_sg\_id](#output\_lb\_sg\_id) | n/a |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | n/a |
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint) | Aurora writer endpoint (null if enable\_rds=false) |
| <a name="output_rds_reader_endpoint"></a> [rds\_reader\_endpoint](#output\_rds\_reader\_endpoint) | Aurora reader endpoint (null if enable\_rds=false) |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
