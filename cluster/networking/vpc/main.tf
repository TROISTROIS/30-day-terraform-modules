resource "aws_vpc" "VPC" {
    cidr_block = var.VPC_CIDR
    tags = {
        Name = "${var.environment}-VPC"
    }
}

resource "aws_subnet" "subnets" {
    for_each = local.subnets 
    availability_zone = data.aws_availability_zones.available.names[each.value.az_index]
    vpc_id = aws_vpc.VPC.id
    cidr_block = each.value.cidr
    map_public_ip_on_launch = true
    tags = {
        Name = each.key
    }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.VPC.id
    tags = {
        Name = "${var.environment}-IGW"
    }
}

resource "aws_route_table" "PublicRouteTable" {
    vpc_id = aws_vpc.VPC.id
}

resource "aws_route" "Route" {
    route_table_id = aws_route_table.PublicRouteTable.id
    destination_cidr_block = local.IGW_destination_IP
    gateway_id = aws_internet_gateway.IGW.id
}

resource "aws_route_table_association" "public_associations" {
  for_each = aws_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.PublicRouteTable.id
}


