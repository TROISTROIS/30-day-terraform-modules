output "vpc_id" {
  value = aws_vpc.VPC.id
}

output "subnet_ids" {
  value = [for s in aws_subnet.subnets : s.id]
}

