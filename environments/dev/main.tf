module "network" {
  source              = "../../modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = ["10.1.0.0/16"]
  subnets = {
    frontend = ["10.1.1.0/24"]
    backend  = ["10.1.2.0/24"]
  }
  nsg_name = var.nsg_name
}

data "azurerm_key_vault" "dev_vault" {
  name                = var.vault_key_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = var.vault_secret_name
  key_vault_id = data.azurerm_key_vault.dev_vault.id
}

module "compute" {
  source              = "../../modules/compute"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.subnet_ids["frontend"]
  admin_username      = var.admin_username
  admin_password      = data.azurerm_key_vault_secret.vm_admin_password.value

  vm_map = {
    "dev-linux-vm"   = { os_type = "Linux", vm_size = "Standard_B1s" }
    "dev-windows-vm" = { os_type = "Windows", vm_size = "Standard_B1s" }
  }

}

module "storage" {
  source               = "../../modules/storage"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_name = var.storage_account_name
  container_name       = var.container_name
}
