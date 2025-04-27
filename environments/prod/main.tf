module "network" {
  source              = "../../modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = "dev-vnet"
  address_space       = ["10.1.0.0/16"]
  subnets = {
    frontend = ["10.1.1.0/24"]
    backend  = ["10.1.2.0/24"]
  }
  nsg_name = "dev-nsg"
}
module "keyvault" {
  source              = "../../modules/keyvault"
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name
  admin_password      = var.admin_password
  admin_password_name = var.admin_password_name
}


data "azurerm_key_vault_secret" "admin_password" {
  name         = var.admin_password_name
  key_vault_id = module.keyvault.keyvault_id
}

module "compute" {
  source              = "../../modules/compute"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.subnet_ids["frontend"]
  admin_username      = var.admin_username
  admin_password      = data.azurerm_key_vault_secret.admin_password.value

  vm_map = {
    "prod-linux-vm"   = { os_type = "Linux", vm_size = "Standard_B1s" }
    "prod-windows-vm" = { os_type = "Windows", vm_size = "Standard_B1s" }
  }
}

module "storage" {
  source               = "../../modules/storage"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_name = "devstoragesa001"
  container_name       = "tfstate1"
}

