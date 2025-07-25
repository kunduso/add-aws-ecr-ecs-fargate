#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "service" {
  name                 = var.name
  cluster              = local.infra_output["aws_ecs_cluster_id"]
  task_definition      = aws_ecs_task_definition.web_app.arn
  desired_count        = 2
  force_new_deployment = true
  load_balancer {
    target_group_arn = local.infra_output["aws_lb_target_group_arn"]
    container_name   = "first"
    container_port   = "8080" # Application Port
  }
  launch_type = "FARGATE"
  network_configuration {
    security_groups  = [local.infra_output["container_security_group_id"]]
    subnets          = local.infra_output["subnet_ids"]
    assign_public_ip = false
  }
  service_connect_configuration {
    enabled = true
    namespace = local.infra_output["service_namespace_arn"]
    service {
      port_name = "http"
      discovery_name = "service-one"
      client_alias {
        port = 80
        dns_name = "service-one.app-6"
      }
    }
    log_configuration {
      log_driver = "awslogs"
      options = {
        awslogs-group = local.infra_output["service_connect_log_group_name"]
        awslogs-region = var.region
        awslogs-stream-prefix = "service-connect"
      }
    }
  }
}