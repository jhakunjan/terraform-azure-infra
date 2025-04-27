output "admin_password" {
  value     = azurerm_key_vault_secret.admin_password.value
  sensitive = true
}

output "keyvault_id" {
  value = azurerm_key_vault.this.id
}

output "keyvault" {
  value = azurerm_key_vault.this
}

