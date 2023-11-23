variable "project" {
  description = "The project name to use for unique resource naming"
  type = string
  default = "terraform-series"
}

variable "principal_arns" {
  type = string
}