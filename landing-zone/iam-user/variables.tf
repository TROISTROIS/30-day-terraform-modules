variable "user_name" {
    description = "The name of the IAM user"
    type = string
}

variable "give_dev_cloudwatch_full_access" {
    description = "If true, dev gets CloudWatch Full Access"
    type = bool
}

variable "cloudwatch_read_only_arn" {
    description = "The ARN of the CloudWatch Read Only policy"
    type        = string
}

variable "cloudwatch_full_access_arn" {
    description = "The ARN of the CloudWatch Full Access policy"
    type        = string
}