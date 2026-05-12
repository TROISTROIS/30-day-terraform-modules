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
}
