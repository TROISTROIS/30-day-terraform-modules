variable "user_name" {
    description = "The name of the IAM user"
    type = string
}

variable "give_dev_cloudwatch_full_access" {
    description = "If true, dev gets CloudWatch Full Access"
    type = bool
}