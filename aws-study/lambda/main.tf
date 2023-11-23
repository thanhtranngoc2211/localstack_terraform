locals {
  project = "terraform-series"
}

module "vpc" {
    source = "./modules/networking"

    project = local.project
}

# module "ec2" {
#     source = "./modules/ec2"

#     project = local.project
#     vpc = module.networking.vpc
# }

module "lambda" {
    source = "./modules/lambda"

    project = local.project
}