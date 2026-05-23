locals {
    IGW_destination_IP = "0.0.0.0./0"
    http_protocol = "HTTP"
    Server_Port = 8080
    subnets = {
    for i in range(var.subnet_count):
    "${var.environment}-subnet-${i+1}" => {
        cidr = cidrsubnet(var.VPC_CIDR, var.newbits , i)
        az_index = i % var.AZs
    }
}
}
