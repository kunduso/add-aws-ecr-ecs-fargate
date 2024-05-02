output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}
output "security_group_id" {
  value = aws_security_group.custom_sg.id
}
output "aws_lb_target_group" {
  value = aws_lb_target_group.target_group.arn
}
output "cluster_name" {
  value = aws_ecs_cluster.app_cluster.name
}
output "cloud_watch_log_group_name" {
  value = aws_cloudwatch_log_group.logs.name
}