data "aws_secretsmanager_secret_version" "credentials" {
    secret_id = data.aws_secretsmanager_secret.db_credentials.id
}