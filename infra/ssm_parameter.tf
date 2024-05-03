#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter
resource "aws_ssm_parameter" "infra_output" {
  name   = "/${var.name}/output"
  type   = "SecureString"
  key_id = aws_kms_key.custom_kms_key.id
  value = jsonencode({
    "subnet_ids" : [for subnet in aws_subnet.private : subnet.id],
    "security_group_id" : "${aws_security_group.custom_sg.id}",
    "aws_lb_target_group" : "${aws_lb_target_group.target_group.arn}",
    "cluster_id" : "${aws_ecs_cluster.app_cluster.id}",
    "cloud_watch_log_group_name" : "${aws_cloudwatch_log_group.logs.name}"
  })
}