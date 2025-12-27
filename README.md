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
```
```
http://vite-react-bucket-12345umesh.s3-website.ap-south-1.amazonaws.com/
