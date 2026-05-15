output "RDS_endpoint" {
    description = "The connection endpoint for the RDS instance"
    value = aws_db_instance.RDS_instance.endpoint
}

output "Address" {
    description = "The ARN of the RDS instance"
    value = aws_db_instance.RDS_instance.address 
}

output "ARN" {
    description = "The ARN of the RDS instance"
    value = aws_db_instance.RDS_instance.arn 
}

output "Port" {
    description = "The port the database is listening on"
    value = aws_db_instance.RDS_instance.port
}
