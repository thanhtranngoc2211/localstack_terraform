output "vpc" {
  value = {
    public_subnets = var.public_subnets
    private_subnets = var.private_subnets
    database_subnets = var.database_subnets
    vpc_id = aws_vpc.main.id
  }
}

output "sg" {
  value = {
    lb = module.alb_sg.security_group.id
    web = module.web_sg.security_group.id
    db = module.db_sg.security_group.id
  }
}