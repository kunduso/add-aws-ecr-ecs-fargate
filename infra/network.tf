resource "aws_service_discovery_http_namespace" "app4" {
  name        = var.name
  description = "The namespace for the ECS cluster. "
}
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "app-4"
  }
}
resource "aws_subnet" "public" {
  count             = length(var.subnet_cidr_public)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.subnet_cidr_public[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    "Name" = "app-4-public-${count.index + 1}"
  }
}
resource "aws_route_table" "this_rt" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "app-4-route-table"
  }
}
resource "aws_route_table_association" "public" {
  count          = length(var.subnet_cidr_public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.this_rt.id
}
resource "aws_security_group" "web_pub_sg" {
  name        = "allow_inbound_access"
  description = "allow inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "from vpc"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }
  tags = {
    "Name" = "app-4-ec2-sg"
  }
}
resource "aws_internet_gateway" "this_igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "app-4-gateway"
  }
}
resource "aws_route" "internet_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.this_rt.id
  gateway_id             = aws_internet_gateway.this_igw.id
}