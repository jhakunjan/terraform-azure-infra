resource "azurerm_key_vault" "this" {
  name                = "kvkunjan-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  soft_delete_retention_days  = 7  
  purge_protection_enabled    = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete",
    ]
}
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = var.admin_password_name
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.this.id
}



data "azurerm_client_config" "current" {}
