output "IAMuser_arn" {
    description = "The ARN of the IAM user"
    value = aws_iam_user.IAMuser.arn
}

output "dev_cloudwatch_policy_arn" {
    value = one(concat(
        aws_iam_user_policy_attachment.dev_cloudwatch_full_access[*].policy_arn,
        aws_iam_user_policy_attachment.dev_cloudwatch_read_only[*].policy_arn
    ))
}