resource "kubernetes_storage_class" "efs_sc" {
  metadata {
    name = "efs-sc"
  }

  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Retain"
  volume_binding_mode = "Immediate"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.main.id
    directoryPerms   = "700"
  }

  depends_on = [
    helm_release.aws_efs_csi_driver,  # ensure the driver is installed
    aws_efs_file_system.main          # ensure FS exists
  ]
}
