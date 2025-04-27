variable "resource_group_name" {}
variable "location" {}
variable "admin_username" {}
variable "admin_password" {}
variable "admin_password_name" {}
variable "environment" {
  description = "The environment for deployment (e.g., dev, stage, prod)"
  type        = string
}