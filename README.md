# Vite React S3 Deployment

Deploy a Vite React application to AWS S3 for static website hosting.

## Prerequisites

- Node.js and npm
- Terraform
- AWS CLI configured with appropriate credentials

## Build the Project

```bash
cd frontend
npm run build
```

## Deploy

### 1. Initialize and Apply Infrastructure

```bash
cd infrastructure
terraform init
terraform apply --auto-approve
```

### 2. Upload Build Files

**Linux/Mac:**
```bash
cd ../frontend
aws s3 sync ./dist s3://$(terraform -chdir=../infrastructure output -raw bucket_name)
```

**Windows (PowerShell):**
```powershell
cd ../frontend
$BUCKET = terraform -chdir=../infrastructure output -raw bucket_name
aws s3 sync ./dist s3://$BUCKET

aws s3 sync ./dist s3://vite-react-bucket-12345umesh
```

Or use the bucket name directly:
```bash
aws s3 sync ./dist s3://vite-react-bucket-12345umesh
```

### 3. Validate

Get the website URL:

```bash
terraform -chdir=infrastructure output bucket_domain_name
```

## Destroy

**Windows (PowerShell):**
```powershell
cd infrastructure
$BUCKET = terraform output -raw bucket_name
aws s3 rm s3://$BUCKET --recursive --quiet
terraform destroy --auto-approve
```

**Linux/Mac:**
```bash
cd infrastructure
BUCKET=$(terraform output -raw bucket_name)
aws s3 rm s3://$BUCKET --recursive --quiet
terraform destroy --auto-approve
```
