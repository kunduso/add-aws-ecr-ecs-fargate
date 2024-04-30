
resource "aws_ecs_service" "mongo" {
  name                 = "web-app"
  cluster              = aws_ecs_cluster.app5.id
  task_definition      = aws_ecs_task_definition.web_app.arn
  desired_count        = 2
  force_new_deployment = true
  load_balancer {
    target_group_arn = aws_lb_target_group.tg_blue.arn
    container_name   = "first"
    container_port   = "8080" # Application Port
  }
  launch_type = "FARGATE"
  network_configuration {
    security_groups  = [aws_security_group.web-pub-sg.id]
    subnets          = [for subnet in aws_subnet.public : subnet.id]
    assign_public_ip = false
  }
  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}