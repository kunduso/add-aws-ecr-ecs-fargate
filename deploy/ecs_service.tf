#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "service" {
  name                 = var.name
  cluster              = local.infra_output["cluster_id"]
  task_definition      = aws_ecs_task_definition.web_app.arn
  desired_count        = 2
  force_new_deployment = true
  load_balancer {
    target_group_arn = local.infra_output["aws_lb_target_group"]
    container_name   = "first"
    container_port   = "8080" # Application Port
  }
  launch_type = "FARGATE"
  network_configuration {
    security_groups  = [local.infra_output["security_group_id"]]
    subnets          = local.infra_output["subnet_ids"]
    assign_public_ip = false
  }
}