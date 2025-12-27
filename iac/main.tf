resource "aws_s3_bucket" "vite_react_bucket" {
    bucket = var.bucket_name
}

# Make the bucket owned by the bucket owner
resource "aws_s3_bucket_ownership_controls" "vite_react_bucket_ownership_controls" {
    bucket = aws_s3_bucket.vite_react_bucket.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

# Make the bucket private (block all public access)
resource "aws_s3_bucket_public_access_block" "vite_react_bucket_block" {
    bucket = aws_s3_bucket.vite_react_bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

# Origin Access Control for CloudFront
resource "aws_cloudfront_origin_access_control" "vite_react_oac" {
    name                              = "${var.bucket_name}-oac"
    description                       = "OAC for ${var.bucket_name}"
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "vite_react_distribution" {
    enabled = true
    comment = "CloudFront distribution for ${var.bucket_name}"

    origin {
        domain_name              = aws_s3_bucket.vite_react_bucket.bucket_regional_domain_name
        origin_id                = "S3-${var.bucket_name}"
        origin_access_control_id = aws_cloudfront_origin_access_control.vite_react_oac.id
    }

    default_root_object = "index.html"

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "S3-${var.bucket_name}"

        viewer_protocol_policy = "redirect-to-https"
        compress               = true

        # Using forwarded_values for simple static site caching
        # Note: This is a legacy approach but works well for static sites
        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
    }

    # Custom error response for SPA routing (404 -> index.html)
    custom_error_response {
        error_code         = 404
        response_code      = 200
        response_page_path = "/index.html"
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }
}

# Bucket policy to allow CloudFront OAC access only
resource "aws_s3_bucket_policy" "vite_react_bucket_policy" {
    bucket = aws_s3_bucket.vite_react_bucket.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid    = "AllowCloudFrontAccess"
                Effect = "Allow"
                Principal = {
                    Service = "cloudfront.amazonaws.com"
                }
                Action   = "s3:GetObject"
                Resource = "${aws_s3_bucket.vite_react_bucket.arn}/*"
                Condition = {
                    StringEquals = {
                        "AWS:SourceArn" = aws_cloudfront_distribution.vite_react_distribution.arn
                    }
                }
            }
        ]
    })
    depends_on = [
        aws_s3_bucket_public_access_block.vite_react_bucket_block,
        aws_cloudfront_distribution.vite_react_distribution
    ]
}