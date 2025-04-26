module "network" {
  source              = "../../modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = "stag-vnet"
  address_space       = ["10.1.0.0/16"]
  subnets = {
    frontend = ["10.1.1.0/24"]
    backend  = ["10.1.2.0/24"]
  }
  nsg_name = "stag-nsg"
}

module "compute" {
  source              = "../../modules/compute"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.subnet_ids["frontend"]
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  vm_map = {
    "stag-linux-vm"  = { os_type = "Linux", vm_size = "Standard_B2s" }
    "stag-windows-vm" = { os_type = "Windows", vm_size = "Standard_B2ms" }
  }
}

module "storage" {
  source                 = "../../modules/storage"
  resource_group_name    = var.resource_group_name
  location               = var.location
  storage_account_name   = "stagstoragesa001"
  container_name         = "tfstate"
}

