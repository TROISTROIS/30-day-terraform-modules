resource "aws_db_instance" "RDS_day13" {
    identifier_prefix = var.prefix
    engine = var.RDS_engine
    allocated_storage = local.storage
    instance_class = local.InstanceType
    skip_final_snapshot = true
    db_name = var.dbname
    username = local.db_credentials.username
    password = local.db_credentials.password
}