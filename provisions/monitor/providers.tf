provider "azurerm" {
  features {}
}



# Azure Client Configuration for authentication
data "azurerm_client_config" "current" {}
