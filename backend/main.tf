# 1. create s3 bucket
resource "aws_s3_bucket" "terraform_state_bucket" {
    bucket = var.s3-backend-bucket
    force_destroy = true
}

# 2. Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "versioning_enabled" {
    bucket = aws_s3_bucket.terraform_state_bucket.id
    versioning_configuration {
      status = "Enabled"
    }
}

# 3. Turn on SSE for all data written to this s3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
    bucket = aws_s3_bucket.terraform_state_bucket.id 
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

# 4. Block all public access to the s3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket = aws_s3_bucket.terraform_state_bucket.id
    block_public_acls = true
    block_public_policy = true 
    ignore_public_acls = true 
    restrict_public_buckets = true 
}

# 5. Create a DynamoDB table
resource "aws_dynamodb_table" "terraform_locks" {
    name = var.dynamodb-backend-table
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type = "S"
    }
}