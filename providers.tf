terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.99.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "saterraformstatekj"
    container_name       = "tfstate"
    key = "${var.environment}/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
