output "vm_public_ip_ids" {
  description = "IDs of the VM Public IP resources"
  value = { for k, ip in azurerm_public_ip.vm_public_ips : k => ip.id }
}