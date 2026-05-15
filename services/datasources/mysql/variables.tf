variable prefix {
    description = "The ID prefix of the RDS instance"
    type = string
}

variable RDS_engine {
    description = "The RDS engine"
    type = string
}

variable "environment" {
    description = "Environment I am working on"
    type = string

    validation {
        condition = contains(["stage", "prod"], var.environment)
        error_message = "Environment must be Stage or Prod. "
    }
}

variable "dbname" {
    description = "The name of the database"
    type = string
    default = null
}

variable "db_username" {
    description = "username for the database"
    type = string
    sensitive = true
    default = null
}

variable "db_password" {
    description = "database password"
    type = string
    sensitive = true
    default = null
}

variable "backup_retention_period" {
    description = "Days to retain backups. Must be > 0 to enable replication"
    type = number
    default = null
}

variable "replicate_source_db" {
    description = "If specified, replicate the RDS instance at the given ARN"
    type = string
    default = null
}