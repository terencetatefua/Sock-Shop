############################################
# EFS StorageClass (managed by EFS CSI add-on)
# Created only when an EFS FS ID is provided.
############################################
resource "kubernetes_storage_class" "efs_sc" {
  count = var.efs_filesystem_id != "" ? 1 : 0

  metadata {
    name = "efs-sc"
  }

  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = var.efs_filesystem_id
    directoryPerms   = "750"
  }

  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"

  # Static dependency only; no dynamic concat/conditionals allowed
  depends_on = [null_resource.wait_gate]
}
