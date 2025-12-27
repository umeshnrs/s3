# Vite React S3 Deployment

Deploy a Vite React application to AWS S3 for static website hosting.

## Prerequisites

- Node.js and npm
- Terraform
- AWS CLI configured with appropriate credentials

## Deployment

### 1. Build the React Application

```bash
cd vite-react
npm run build
```

### 2. Deploy Infrastructure

```bash
cd ../iac
terraform init
terraform apply --auto-approve
```

### 3. Upload Build Files

```bash
cd ../vite-react
aws s3 sync ./dist s3://vite-react-bucket-12345umesh
```

### 4. Access Your Site

The website URL will be displayed after running `terraform apply`. You can also retrieve it with:

```bash
terraform -chdir=iac output bucket_domain_name

http://vite-react-bucket-12345umesh.s3-website.ap-south-1.amazonaws.com/
```
```
## Destroy Resources (Remove All Infrastructure)

To remove all resources and avoid costs, you can destroy the Terraform infrastructure:

### Option 1: Use Destroy Script (Easiest)

**Linux/Mac:**
```bash
cd iac
chmod +x destroy.sh
./destroy.sh
```

**Windows (PowerShell):**
```powershell
cd iac
.\destroy.ps1
```

### Option 2: Destroy with Auto-Approval (Manual)

```bash
cd iac
terraform destroy --auto-approve
```

This will remove:
- S3 bucket and all its contents
- Bucket policies
- Website configuration
- Public access settings
- Ownership controls

### Option 2: Empty Bucket First (If Destroy Fails)

If the bucket contains objects and destroy fails, empty the bucket first:

```bash
# Get the bucket name from Terraform output
BUCKET_NAME=$(terraform -chdir=iac output -raw bucket_name)

# Empty the bucket
aws s3 rm s3://$BUCKET_NAME --recursive

# Then destroy
terraform -chdir=iac destroy --auto-approve
```

### Option 3: Force Destroy (Alternative)

If you encounter issues with non-empty buckets, you can force destroy:

```bash
cd iac
terraform destroy --auto-approve -force
```

**Note:** After destroying, verify no resources remain to avoid unexpected costs:
```bash
aws s3 ls
```