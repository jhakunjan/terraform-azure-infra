variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "RG-DEV-002"
}

variable "location" {
  description = "The Azure location for resources"
  default     = "Central India"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  default     = "saterraformstatekj"
}

variable "vm_name" {
  description = "The name of the existing Virtual Machine"
  default     = "dev-linux-vm"
}




