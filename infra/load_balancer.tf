#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "app_lb" {
  #checkov:skip=CKV_AWS_91: Access logging is disabled since this is non-prod.
  #checkov:skip=CKV2_AWS_20: This is disabled since this is non-prod.
  #checkov:skip=CKV2_AWS_28: This is disabled since this is non-prod.
  name                       = var.name
  load_balancer_type         = "application"
  subnets                    = [for subnet in aws_subnet.public : subnet.id]
  idle_timeout               = 60
  security_groups            = [aws_security_group.custom_sg.id]
  internal                   = false
  enable_deletion_protection = true
  drop_invalid_header_fields = true
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "target_group" {
  name        = var.name
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.this.id
  health_check {
    matcher = "200,301,302,404"
    path    = "/"
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_alb_listener" "listener" {
  #checkov:skip=CKV_AWS_2: This is disabled since this is non-prod.
  #checkov:skip=CKV_AWS_103: This is disabled since this is non-prod.
  load_balancer_arn = aws_lb.app_lb.id
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
  lifecycle {
    ignore_changes = [default_action]
  }
}