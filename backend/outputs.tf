output "state-s3-bucket-name" {
    description = "The name of the backend state bucket"
    value = aws_s3_bucket.terraform_state_bucket.bucket
}

output "state-dynamodb-table" {
    description = "The name of the state dynamodb table"
    value = aws_dynamodb_table.terraform_locks.name
}