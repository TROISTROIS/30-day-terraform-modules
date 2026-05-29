locals {
    common_tags = {
        environment = var.environment
        ManagedBy = "terraform"
        Project = "Day-${var.day}"
    }
}