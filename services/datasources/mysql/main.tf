terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0 "
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias = "primary"
}

provider "aws" {
  region = "us-west-1"
  alias = "secondary"
}

resource "aws_db_instance" "RDS_instance" {
    identifier_prefix = var.prefix
    allocated_storage = local.storage
    instance_class = local.InstanceType
    skip_final_snapshot = true
    backup_retention_period = var.backup_retention_period

    replicate_source_db = var.replicate_source_db
    engine = var.replicate_source_db == null ? var.RDS_engine : null
    db_name = var.replicate_source_db ==  null ? var.dbname : null
    username = var.replicate_source_db == null ? var.db_username : null
    password = var.replicate_source_db == null ? var.db_password : null
}