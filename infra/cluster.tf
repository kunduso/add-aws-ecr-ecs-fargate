#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_cluster" "app_cluster" {
  name = var.name
  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"
      kms_key_id = aws_kms_key.custom_kms_key.id
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.logs.name
      }
    }
  }
  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.namespace.arn
  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}