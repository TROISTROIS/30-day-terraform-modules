locals {
    IGW_destination_IP = "0.0.0.0./0"
    ELB_Port = 80
    Server_Port = 8080
    tcp_protocol = "tcp"
    http_protocol = "HTTP"
    any_protocol = "-1"
    is_production = var.environment == "Production"
    InstanceType = local.is_production ? "t2.micro" : "t2.nano"
    min_cluster_size = local.is_production ? 3 : 1
    max_cluster_size = local.is_production ? 5 : 3
}