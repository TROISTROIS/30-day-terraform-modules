variable "s3-backend-bucket" {
    description = "The name of the state s3 bucket"
    type = string
}

variable "dynamodb-backend-table" {
    description = "The name of the dynamodb table"
    type = string
}