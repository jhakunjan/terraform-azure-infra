variable "resource_group_name" {}
variable "location" {}
variable "subnet_id" {}
variable "admin_username" {}
variable "admin_password" {}
variable "vm_map" { type = map(any) }
