variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the resources"
  type        = string
}

variable "admin_username" {
  description = "The username for the Linux VM administrator"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID where the VM resides"
  type        = string
}

variable "nsg_id" {
  description = "The ID of the network security group to associate with the NIC"
  type        = string
}

variable "vault_name" {
  description = "The name of the Azure Key Vault"
  type        = string
}

variable "vault_secret_name" {
  description = "The name of the secret in the Key Vault for the VM admin password"
  type        = string
}
