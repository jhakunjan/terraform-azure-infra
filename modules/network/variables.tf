variable "vnet_name" {}
variable "address_space" { type = list(string) }
variable "location" {}
variable "resource_group_name" {}
variable "subnets" { type = map(list(string)) }
variable "nsg_name" {}

