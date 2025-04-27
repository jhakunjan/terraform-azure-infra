terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "saterraformstatekj"
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "fb141b80-2b4d-4a51-a02b-ac95ac80ae0d"
}
  
