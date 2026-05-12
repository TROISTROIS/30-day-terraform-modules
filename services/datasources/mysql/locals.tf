locals {
    is_production = var.environment == "prod"
    InstanceType = local.is_production ? "db.t3.micro" : "db.t2.micro"
    storage = local.is_production ? 10 : 5
    db_credentials = jsondecode(
        data.aws_secretsmanager_secret_version.credentials.secret_string
    )
}