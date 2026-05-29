variable "s3-backend-bucket" {
    description = "The name of the state s3 bucket"
    type = string
}

variable "dynamodb-backend-table" {
    description = "The name of the dynamodb table"
    type = string
}

variable "environment" {
    description = "Environment I am working on"
    type = string

    validation {
        condition = contains(["Stage", "Production", "Test"], var.environment)
        error_message = "Environment must be Stage , Test or Production. "
    }
}

variable "day" {
    description = "The day of the challenge"
    type = number
}