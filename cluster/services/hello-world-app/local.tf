locals {
    enable_autoscaling = var.environment == "Production"
    http_protocol = "HTTP"
    Server_Port = 8080
        common_tags = {
        environment = var.environment
        ManagedBy = "terraform"
        Project = "Day-${var.day}"
    }
}