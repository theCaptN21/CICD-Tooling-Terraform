# --- networking.tf ---

provider "aws" {
  region = var.region
}

resource "random_integer" "random" {
  min = 1
  max = 50
}

#VPC

resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

#Gateways & EIP

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_eip" "ecs_eip" {
  vpc = true
}

resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.ecs_eip.id
  subnet_id     = aws_subnet.ecs_public.id
}

#Subnets

resource "aws_subnet" "ecs_public" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = var.public_cidrs
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones

  tags = {
    Name = "ecs_public"
  }
}

resource "aws_subnet" "ecs_private" {
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = var.private_cidrs
  availability_zone = var.availability_zones

  tags = {
    Name = "ecs_private"
  }

}

#Route Tables & Associations

resource "aws_route_table" "PriRT_rt" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ecs_private"
  }
}

resource "aws_route_table_association" "PriRT_association" {
  count          = length(var.private_cidrs)
  subnet_id      = aws_subnet.ecs_private.id
  route_table_id = aws_route_table.PriRT_rt.id
}

#Security Groups

resource "aws_security_group" "ecs_private_sg" {
  name        = "ecs-provide-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}