provider "azurerm" {
  features {}
  subscription_id = "fb141b80-2b4d-4a51-a02b-ac95ac80ae0d"
}

resource "azurerm_virtual_machine_extension" "install_docker" {
  name                 = "installDockerExtension"
  virtual_machine_id   = "/subscriptions/fb141b80-2b4d-4a51-a02b-ac95ac80ae0d/resourceGroups/RG-DEV-002/providers/Microsoft.Compute/virtualMachines/dev-linux-vm"
  publisher             = "Microsoft.Azure.Extensions"
  type                  = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
      "script": "${file("scripts/install_docker.sh")}"
    }
SETTINGS
}
