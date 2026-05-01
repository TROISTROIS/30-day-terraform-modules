output "IAMuser_arn" {
    description = "The ARN of the IAM user"
    value = aws_iam_user.IAMuser.arn
}