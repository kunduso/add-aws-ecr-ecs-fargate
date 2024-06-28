#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret
resource "aws_secretsmanager_secret" "ecs_secret" {
  #checkov:skip=CKV2_AWS_57: This variable does not need to be rotated
  name                    = "ecs_secret"
  recovery_window_in_days = 0
  kms_key_id              = aws_kms_key.custom_kms_key.id
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version
resource "aws_secretsmanager_secret_version" "ecs_secret_version" {
  secret_id     = aws_secretsmanager_secret.ecs_secret.id
  secret_string = var.ecs_secret
  #The value is passed to the Terraform via the CLI
}