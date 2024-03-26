resource "aws_ecs_cluster" "app_cluster" {
  name = var.name
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
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