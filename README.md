# Vite React S3 Deployment

Deploy a Vite React application to AWS S3 for static website hosting.

## Prerequisites

- Node.js and npm
- Terraform
- AWS CLI configured with appropriate credentials

## Build the Project

```bash
cd vite-react
npm run build
```

## Deploy

### 1. Initialize Terraform

```bash
cd iac
terraform init
```

### 2. Apply Infrastructure

```bash
terraform apply --auto-approve
```

### 3. Upload Build Files

**Linux/Mac:**
```bash
cd ../vite-react
aws s3 sync ./dist s3://$(terraform -chdir=../iac output -raw bucket_name)
```

**Windows (PowerShell):**
```powershell
cd ../vite-react
$BUCKET = terraform -chdir=../iac output -raw bucket_name
aws s3 sync ./dist s3://$BUCKET

aws s3 sync ./dist s3://vite-react-bucket-12345umesh
```

Or use the bucket name directly:
```bash
aws s3 sync ./dist s3://vite-react-bucket-12345umesh
```

### 4. Validate

Get the website URL:

```bash
terraform -chdir=iac output bucket_domain_name
```

## Destroy

```bash
cd iac
terraform destroy --auto-approve
```
