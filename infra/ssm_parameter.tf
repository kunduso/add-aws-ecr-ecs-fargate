#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter
resource "aws_ssm_parameter" "infra_output" {
  name        = "/${var.name}/output"
  description = "Infrastructure layer resources."
  type        = "SecureString"
  key_id      = aws_kms_key.custom_kms_key.id
  value = jsonencode({
    "subnet_ids" : [for subnet in aws_subnet.private : subnet.id],
    "container_security_group_id" : "${aws_security_group.container_sg.id}",
    "aws_lb_blue_target_group_arn" : "${aws_lb_target_group.blue_target_group.arn}",
    "aws_lb_green_target_group_arn" : "${aws_lb_target_group.green_target_group.arn}",
    "aws_lb_blue_target_group_name" : "${aws_lb_target_group.blue_target_group.name}",
    "aws_lb_green_target_group_name" : "${aws_lb_target_group.green_target_group.name}",
    "aws_lb_listener" : "${aws_alb_listener.listener.arn}",
    "aws_lb" : "${aws_lb.app_lb.arn}",
    "aws_vpc_id" : "${aws_vpc.this.id}",
    "aws_ecs_cluster_id" : "${aws_ecs_cluster.app_cluster.id}",
    "aws_ecs_cluster_name" : "${aws_ecs_cluster.app_cluster.name}",
    "aws_cloudwatch_log_group" : "${aws_cloudwatch_log_group.logs.arn}",
    "aws_cloudwatch_log_group_name" : "${aws_cloudwatch_log_group.logs.name}",
    "secret_arn" : "${aws_secretsmanager_secret.ecs_secret.arn}",
    "kms_arn" : "${aws_kms_key.custom_kms_key.arn}"
  })
}