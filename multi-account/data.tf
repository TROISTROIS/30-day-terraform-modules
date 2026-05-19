data "aws_caller_identity" "stage" {
provider = aws.stage
}

data "aws_caller_identity" "prod" {
provider = aws.prod
}