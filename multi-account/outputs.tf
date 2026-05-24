output "stage_account" {
value = data.aws_caller_identity.stage.account_id
description = "The ID of the stage AWS account"
}

output "prod_account" {
value = data.aws_caller_identity.prod.account_id
description = "The ID of the prod AWS account"
}