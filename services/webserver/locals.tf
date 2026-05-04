locals {
    IGW_destination_IP = "0.0.0.0/0"
    ELB_Port = 80
    Server_Port = 8080
    tcp_protocol = "tcp"
    http_protocol = "HTTP"
    any_protocol = "-1"
    InstanceType = var.Environment == "Production" ? "t2.micro" : "t2.nano"
    min_cluster_size = var.Environment == "Production" ? 3 : 1
    max_cluster_size = var.Environment == "Production" ? 5 : 2
    subnets = {
        for i in range(var.subnet_count):
        "Subnet${i+1}" => {
            cidr = cidrsubnet(var.VPC_CIDR, var.newbits , i)
            az_index = i % var.AZs
        }
    }
}


