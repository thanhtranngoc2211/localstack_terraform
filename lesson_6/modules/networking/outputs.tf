output "vpc" {
  value = {
    private_subnets = var.private_subnets
    database_subnets = var.database_subnets
  }
}

output "sg" {
  value = {
    lb = module.lb_sg.security_group.id
    web = module.web_sg.security_group.id
    db = module.db_sg.security_group.id
  }
}