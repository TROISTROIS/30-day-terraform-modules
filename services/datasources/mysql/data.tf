data "aws_secretsmanager_secret_version" "credentials" {
    secret_id = "RDScreds"
}