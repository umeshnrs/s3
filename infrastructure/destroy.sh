#!/bin/bash

# Script to destroy all Terraform resources and remove S3 bucket contents
# This ensures no costs are incurred after destruction

set -e

echo "Destroying Terraform infrastructure..."

# Get the bucket name from Terraform output (if it exists)
BUCKET_NAME=$(terraform output -raw bucket_name 2>/dev/null || echo "")

# If bucket exists and has a name, try to empty it first
if [ ! -z "$BUCKET_NAME" ]; then
    echo "Emptying S3 bucket: $BUCKET_NAME"
    aws s3 rm s3://$BUCKET_NAME --recursive --quiet || echo "Bucket may already be empty or not exist"
fi

# Destroy all Terraform resources
echo "Running terraform destroy..."
terraform destroy --auto-approve

echo "✅ All resources have been destroyed. No costs should be incurred."

