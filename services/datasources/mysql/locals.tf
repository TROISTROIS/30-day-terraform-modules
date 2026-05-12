locals {
    is_production = var.environment == "prod"
    InstanceType = local.is_production ? "db.t3.small" : "db.t3.micro"
    storage = local.is_production ? 10 : 5
}