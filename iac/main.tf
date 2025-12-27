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

# Make the bucket publically accessible
resource "aws_s3_bucket_public_access_block" "vite_react_bucket_block" {
    bucket = aws_s3_bucket.vite_react_bucket.id
    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

# Configure the bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "vite_react_website" {
    bucket = aws_s3_bucket.vite_react_bucket.id
    index_document {
        suffix = "index.html"
    }
    error_document {
        key = "index.html" # React app default index.html in all cases
    }
}

# Make all files in bucket readable
resource "aws_s3_bucket_policy" "vite_react_bucket_policy" {
    bucket = aws_s3_bucket.vite_react_bucket.id
    policy=jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.vite_react_bucket.arn}/*"
            }
        ]
    })
    depends_on = [
        aws_s3_bucket_public_access_block.vite_react_bucket_block
    ]
}