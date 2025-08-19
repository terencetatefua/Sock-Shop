resource "null_resource" "wait_for_cluster" {
  triggers = {
    cluster = var.eks_cluster_name
    region  = var.region
    kcfg    = var.kubeconfig_path
  }

  provisioner "local-exec" {
    command     = <<-EOC
      set -euo pipefail

      REGION='${var.region}'
      CLUSTER='${var.eks_cluster_name}'
      KCFG_WIN='${var.kubeconfig_path}'

      # Normalize Windows path for Git Bash/MSYS (C:\... -> /c/...) and backslashes -> slashes
      KCFG_POSIX="$(printf '%s' "$KCFG_WIN" | sed -E 's#^([A-Za-z]):#/\L\\1#; s#\\\\#/#g')"

      echo "🔄 Waiting for EKS cluster to become ACTIVE..."
      for i in {1..90}; do  # up to ~15m
        STATUS=$(aws eks describe-cluster --region "$REGION" --name "$CLUSTER" --query 'cluster.status' --output text 2>/dev/null || echo "MISSING")
        if [ "$STATUS" = "ACTIVE" ]; then
          break
        fi
        echo "🕒 Cluster status=$STATUS; waiting..."
        sleep 10
      done

      if [ "$STATUS" != "ACTIVE" ]; then
        echo "❌ Cluster not ACTIVE after 15 minutes"; exit 1
      fi

      echo "🔁 Updating kubeconfig (explicit path + default path for safety)..."
      aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER" --kubeconfig "$KCFG_WIN"
      aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER"

      echo "✅ Testing Kubernetes API reachability..."
      : > err.txt
      for i in {1..120}; do  # up to ~10m
        # 1) /version often returns 401/403 when API is up (that's fine)
        if KUBECONFIG="$KCFG_POSIX" kubectl get --raw=/version --request-timeout=5s >/dev/null 2>err.txt; then
          echo "🎉 Kubernetes API reachable (/version)."; exit 0
        fi

        # 2) /livez check
        if KUBECONFIG="$KCFG_POSIX" kubectl get --raw=/livez --request-timeout=5s >/dev/null 2>>err.txt; then
          echo "🎉 Kubernetes API reachable (/livez)."; exit 0
        fi

        # 3) kubectl version (without --short, it's deprecated)
        if KUBECONFIG="$KCFG_POSIX" kubectl version --request-timeout=5s >/dev/null 2>>err.txt; then
          echo "🎉 Kubernetes API reachable (kubectl version)."; exit 0
        fi

        # If endpoint is up but auth not granted yet, we'll see 401/403 — still means API is up
        if grep -qiE 'Unauthorized|Forbidden|You must be logged in to the server' err.txt; then
          echo "🎉 Kubernetes API reachable (received 401/403; endpoint is up)."; exit 0
        fi

        echo "⌛ Waiting for Kubernetes API... ($i)"
        sleep 5
      done

      echo "❌ Kubernetes API not reachable after ~10 minutes"
      echo "---- last kubectl errors ----"
      sed -n '1,200p' err.txt || true
      exit 1
    EOC
    interpreter = ["bash", "-lc"]
  }

  # Wait for the nested eks module exposed by the shared module
  depends_on = [module.shared.eks_module]
}
