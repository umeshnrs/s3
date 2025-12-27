output "bucket_name" {
    value       = aws_s3_bucket.vite_react_bucket.bucket
    description = "The name of the bucket to deploy the React app to"
}

output "cloudfront_url" {
    value       = "https://${aws_cloudfront_distribution.vite_react_distribution.domain_name}"
    description = "CloudFront distribution URL (use this to access your application)"
}
