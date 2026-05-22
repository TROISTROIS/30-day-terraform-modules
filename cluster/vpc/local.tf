locals {
    IGW_destination_IP = "0.0.0.0./0"
    subnets = {
    for i in range(var.subnet_count):
    "${var.environment}-subnet-${i+1}" => {
        cidr = cidrsubnet(var.VPC_CIDR, var.newbits , i)
        az_index = i % var.AZs
    }
}
}