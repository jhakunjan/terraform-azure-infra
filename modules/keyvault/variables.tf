variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "location" {
  description = "Azure location for Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for Key Vault"
  type        = string
}

variable "admin_password" {
  description = "VM Admin Password"
  type        = string
  sensitive   = true
}

variable "admin_password_name" {
  description = "Name of the admin password secret in Key Vault."
  type        = string
}


