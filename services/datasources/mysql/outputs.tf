output "rds_endpoint" {
    description = "The connection endpoint for the RDS instance"
    value = aws_db_instance.RDS_instance.endpoint
}

output "arn" {
    description = "The ARN of the RDS instance"
    value = aws_db_instance.RDS_instance.arn 
}