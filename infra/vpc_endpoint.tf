# resource "aws_security_group" "endpoint-sg" {
#   name        = "endpoint_access"
#   description = "allow inbound traffic"
#   vpc_id      = aws_vpc.this.id
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.this.cidr_block]
#     description = "Enable access for the endpoints."
#   }
#   tags = {
#     "Name" = "app-5-endpoint-sg"
#   }
# }
# resource "aws_vpc_endpoint" "ecr" {
#   vpc_id              = aws_vpc.this.id
#   service_name        = "com.amazonaws.us-east-2.ecr.dkr"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [for subnet in aws_subnet.private : subnet.id]
#   security_group_ids  = [aws_security_group.endpoint-sg.id]
#   private_dns_enabled = true
#   tags = {
#     "Name" = "${var.name}-ecr"
#   }
# }
# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id              = aws_vpc.this.id
#   service_name        = "com.amazonaws.us-east-2.ecr.api"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [for subnet in aws_subnet.private : subnet.id]
#   security_group_ids  = [aws_security_group.endpoint-sg.id]
#   private_dns_enabled = true
#   tags = {
#     "Name" = "${var.name}-ecr-api"
#   }
# }
# resource "aws_vpc_endpoint" "cloudwatch" {
#   vpc_id              = aws_vpc.this.id
#   service_name        = "com.amazonaws.us-east-2.logs"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [for subnet in aws_subnet.private : subnet.id]
#   security_group_ids  = [aws_security_group.endpoint-sg.id]
#   private_dns_enabled = true
#   tags = {
#     "Name" = "${var.name}-logs"
#   }
# }
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = aws_vpc.this.id
#   service_name      = "com.amazonaws.us-east-2.s3"
#   vpc_endpoint_type = "Gateway"
#   tags = {
#     "Name" = "${var.name}-s3"
#   }
# }
# resource "aws_vpc_endpoint_route_table_association" "s3_association" {
#   route_table_id  = aws_route_table.this-rt.id
#   vpc_endpoint_id = aws_vpc_endpoint.s3.id
# }