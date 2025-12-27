# PowerShell script to destroy all Terraform resources and remove S3 bucket contents
# This ensures no costs are incurred after destruction

Write-Host "Destroying Terraform infrastructure..." -ForegroundColor Yellow

# Get the bucket name from Terraform output (if it exists)
try {
    $bucketName = terraform output -raw bucket_name 2>$null
    if ($bucketName) {
        Write-Host "Emptying S3 bucket: $bucketName" -ForegroundColor Yellow
        aws s3 rm "s3://$bucketName" --recursive --quiet
    }
} catch {
    Write-Host "Bucket may already be empty or not exist" -ForegroundColor Gray
}

# Destroy all Terraform resources
Write-Host "Running terraform destroy..." -ForegroundColor Yellow
terraform destroy --auto-approve

Write-Host "✅ All resources have been destroyed. No costs should be incurred." -ForegroundColor Green

