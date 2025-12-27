output "bucket_name" {
    value = aws_s3_bucket.vite_react_bucket.bucket
    description = "The name of the bucket to deploy the React app to"
}

output "bucket_domain_name" {
    value = "https://${var.bucket_name}.s3-website.${var.region}.amazonaws.com"
    description = "URL of the bucket to deploy the React app to"
}
