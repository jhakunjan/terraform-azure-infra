resource "azurerm_network_interface" "nics" {
  for_each = var.vm_map
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "windows_vms" {
  for_each = { for k, v in var.vm_map : k => v if v.os_type == "Windows" }
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = each.value.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.nics[each.key].id]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "linux_vms" {
  for_each = { for k, v in var.vm_map : k => v if v.os_type == "Linux" }
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = each.value.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nics[each.key].id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
