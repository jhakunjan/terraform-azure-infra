resource "azurerm_public_ip" "vm_public_ips" {
  for_each = var.vm_map

  name                         = "${each.key}-public-ip"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  allocation_method            = "Dynamic"  
  sku                          = "Basic"    
  tags = {
    environment = "Dev"
  }
}

resource "azurerm_network_interface" "nics" {
  for_each = var.vm_map
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ips[each.key].id
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

  os_disk {
    name              = "${each.key}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

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

  os_disk {
    name              = "${each.key}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  custom_data = base64encode(file("${path.module}/install_docker.sh"))
  connection {
    type     = "ssh"
    user     = var.admin_username
    password = var.admin_password
    host     = azurerm_public_ip.vm_public_ips[each.key].ip_address
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo usermod -aG docker ${var.admin_username}",
      "sudo curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "docker --version",
      "docker-compose --version"
    ]
  }
  
}
