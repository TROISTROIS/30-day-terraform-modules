resource "aws_iam_user" "IAMuser" {
    name = var.user_name
}

resource "aws_iam_policy" "cloudwatch_read_only" {
    name = "cloudwatch-read-only"
    policy = data.aws_iam_policy_document.cloudwatch_read_only_policy.json
}

data "aws_iam_policy_document" "cloudwatch_read_only_policy" {
    statement {
        effect = "Allow"
        actions = [
            "cloudwatch:Describe*",
            "cloudwatch:Get*",
            "cloudwatch:List*"
            ]
            resources = ["*"]
            }
            }

resource "aws_iam_policy" "cloudwatch_full_access" {
    name = "cloudwatch-full-access"
    policy = data.aws_iam_policy_document.cloudwatch_full_access_policy.json
    }

data "aws_iam_policy_document" "cloudwatch_full_access_policy" {
    statement {
        effect = "Allow"
        actions = ["cloudwatch:*"]
        resources = ["*"]
        }
        } 

resource "aws_iam_user_policy_attachment" "dev_cloudwatch_full_access" {
    count = var.give_dev_cloudwatch_full_access ? 1 : 0

    user = aws_iam_user.IAMuser.name
    policy_arn = aws_iam_policy.cloudwatch_full_access.arn 
}

resource "aws_iam_user_policy_attachment" "dev_cloudwatch_read_only" {
    count = var.give_dev_cloudwatch_full_access ? 0 : 1
    
    user = aws_iam_user.IAMuser.name
    policy_arn = aws_iam_policy.cloudwatch_read_only.arn 
}
