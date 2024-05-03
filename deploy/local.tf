data "aws_caller_identity" "current" {}
data "aws_ssm_parameter" "infra_output" {
  name = "/${var.name}/output"
}
locals {
  infra_output       = jsondecode(data.aws_ssm_parameter.infra_output.value)
  principal_root_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  principal_logs_arn = "logs.${var.region}.amazonaws.com"
  ecs_log_group_arn  = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/amazon-ecs/${var.name}/log"
}