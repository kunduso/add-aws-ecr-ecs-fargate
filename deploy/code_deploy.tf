#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app
resource "aws_codedeploy_app" "application_main" {
  compute_platform = "ECS"
  name             = var.name
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group
resource "aws_codedeploy_deployment_group" "application_main" {
  app_name               = aws_codedeploy_app.application_main.name
  deployment_group_name  = "${var.name}-deploy-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.codedeploy_role.arn
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }
  ecs_service {
    cluster_name = local.infra_output["aws_ecs_cluster_name"]
    service_name = aws_ecs_service.service.name
  }
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [local.infra_output["aws_lb_listener"]]
      }
      target_group {
        name = local.infra_output["aws_lb_blue_target_group_name"]
      }
      target_group {
        name = local.infra_output["aws_lb_green_target_group_name"]
      }
    }
  }
  lifecycle {
    ignore_changes = [blue_green_deployment_config]
  }
}