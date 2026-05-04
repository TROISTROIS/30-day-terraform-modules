resource "aws_iam_user" "IAMuser" {
    name = var.user_name
}

resource "aws_iam_user_policy_attachment" "dev_cloudwatch_full_access" {
    count = var.give_dev_cloudwatch_full_access ? 1 : 0

    user = aws_iam_user.IAMuser[0].name
    policy_arn = aws_iam_policy.cloudwatch_full_access_arn 
}

resource "aws_iam_user_policy_attachment" "dev_cloudwatch_read_only" {
    count = var.give_dev_cloudwatch_full_access ? 0 : 1
    
    user = aws_iam_user.IAMuser[0].name
    policy_arn = aws_iam_policy.cloudwatch_read_only_arn 
}
