resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "private_sub" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
}

resource "aws_subnet" "database_sub" {
  count = length(var.database_subnets)

  vpc_id = aws_vpc.main.id
  cidr_block = var.database_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
}

resource "aws_subnet" "public_sub" {
  count = length(var.public_subnets)

  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "default" {
  subnet_id = aws_subnet.public_sub[0].id
  allocation_id = aws_eip.nat.id
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.default.id
  }
}

resource "aws_route_table_association" "public_association" {
  for_each = { for k, v in aws_subnet.public_sub : k => v }
  subnet_id = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_association" {
  for_each = { for k, v in aws_subnet.private_sub : k => v }
  subnet_id = each.value.id
  route_table_id = aws_route_table.private.id
}

module "alb_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = aws_vpc.main.id
  ingress_rules = [
    {
      port        = 80
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "web_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = aws_vpc.main.id
  ingress_rules = [
    {
      port        = 80
      security_groups = [module.alb_sg.security_group.id]
    }
  ]
}

module "db_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = aws_vpc.main.id
  ingress_rules = [
    {
      port            = 5432
      security_groups = [module.web_sg.security_group.id]
    }
  ]
}

