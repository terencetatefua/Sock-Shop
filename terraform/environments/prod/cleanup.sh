#!/usr/bin/env bash
set -euo pipefail

REGION="us-east-2"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# --- EFS ---
FS_ID="fs-0d0b5dea16a197655"
echo "🗑️ Cleaning EFS $FS_ID in $REGION"

# Delete mount targets
MT_IDS=$(aws efs describe-mount-targets \
  --file-system-id "$FS_ID" \
  --region "$REGION" \
  --query 'MountTargets[].MountTargetId' \
  --output text | tr '\t' '\n')

for MT in $MT_IDS; do
  echo "  - Deleting mount target $MT"
  aws efs delete-mount-target --mount-target-id "$MT" --region "$REGION"
done

# Delete access points
AP_IDS=$(aws efs describe-access-points \
  --file-system-id "$FS_ID" \
  --region "$REGION" \
  --query 'AccessPoints[].AccessPointId' \
  --output text | tr '\t' '\n')

for AP in $AP_IDS; do
  echo "  - Deleting access point $AP"
  aws efs delete-access-point --access-point-id "$AP" --region "$REGION"
done

# Delete the filesystem
if [ -n "$FS_ID" ]; then
  echo "  - Deleting file system $FS_ID"
  aws efs delete-file-system --file-system-id "$FS_ID" --region "$REGION" || true
fi

# --- IAM Policy ---
POLICY_ARN="arn:aws:iam::$ACCOUNT_ID:policy/irsa-secretsmanager-read-prod"
echo "🗑️ Cleaning IAM Policy $POLICY_ARN"

# Detach from roles
ROLES=$(aws iam list-entities-for-policy --policy-arn "$POLICY_ARN" \
  --query 'PolicyRoles[].RoleName' --output text | tr '\t' '\n')
for ROLE in $ROLES; do
  [ -z "$ROLE" ] && continue
  echo "  - Detaching from role $ROLE"
  aws iam detach-role-policy --role-name "$ROLE" --policy-arn "$POLICY_ARN"
done

# Detach from users
USERS=$(aws iam list-entities-for-policy --policy-arn "$POLICY_ARN" \
  --query 'PolicyUsers[].UserName' --output text | tr '\t' '\n')
for USER in $USERS; do
  [ -z "$USER" ] && continue
  echo "  - Detaching from user $USER"
  aws iam detach-user-policy --user-name "$USER" --policy-arn "$POLICY_ARN"
done

# Detach from groups
GROUPS=$(aws iam list-entities-for-policy --policy-arn "$POLICY_ARN" \
  --query 'PolicyGroups[].GroupName' --output text | tr '\t' '\n')
for GROUP in $GROUPS; do
  [ -z "$GROUP" ] && continue
  echo "  - Detaching from group $GROUP"
  aws iam detach-group-policy --group-name "$GROUP" --policy-arn "$POLICY_ARN"
done

# Delete policy
aws iam delete-policy --policy-arn "$POLICY_ARN" || true

# --- KMS Alias ---
echo "🗑️ Deleting KMS alias alias/eks/sockshop-prod"
aws kms delete-alias --alias-name alias/eks/sockshop-prod --region "$REGION" || true

# --- CloudWatch Log Group ---
echo "🗑️ Deleting CloudWatch log group /aws/eks/sockshop-prod/cluster"
MSYS_NO_PATHCONV=1 aws logs delete-log-group \
  --log-group-name /aws/eks/sockshop-prod/cluster \
  --region "$REGION" || true

echo "✅ Cleanup complete"
