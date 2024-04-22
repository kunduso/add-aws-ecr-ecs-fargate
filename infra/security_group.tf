#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "custom_sg" {
  name        = "${var.name}_allow_inbound_access"
  description = "allow inbound traffic"
  vpc_id      = aws_vpc.this.id
  tags = {
    "Name" = "${var.name}-sg"
  }
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
resource "aws_security_group_rule" "ingress" {
  description       = "allow traffic into the load balancer"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.custom_sg.id
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
resource "aws_security_group_rule" "egress" {
  description       = "allow traffic to reach outside the vpc"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.custom_sg.id
}