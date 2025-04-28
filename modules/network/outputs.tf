output "subnet_ids" {
  value = { for s in azurerm_subnet.subnets : s.name => s.id }
}
output "nsg_id" {
  description = "The ID of the network security group"
  value       = azurerm_network_security_group.nsg.id
}

