#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_http_namespace
resource "aws_service_discovery_http_namespace" "namespace" {
  name        = var.name
  description = "The namespace for the ECS cluster. "
}
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "${var.name}"
  }
}
resource "aws_subnet" "public" {
  count             = length(var.subnet_cidr_public)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.subnet_cidr_public[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    "Name" = "${var.name}-public-${count.index + 1}"
  }
}
resource "aws_route_table" "this_rt" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "${var.name}-route-table"
  }
}
resource "aws_route_table_association" "public" {
  count          = length(var.subnet_cidr_public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.this_rt.id
}
resource "aws_security_group" "web_pub_sg" {
  name        = "${var.name}_allow_inbound_access"
  description = "allow inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "traffic from the internet"
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "traffic from the container"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.name}-ec2-sg"
  }
}
resource "aws_internet_gateway" "this_igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "${var.name}-gateway"
  }
}
resource "aws_route" "internet_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.this_rt.id
  gateway_id             = aws_internet_gateway.this_igw.id
}