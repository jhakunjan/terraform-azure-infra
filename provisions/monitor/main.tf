resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Define a virtual machine (already created)
data "azurerm_linux_virtual_machine" "example" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.example.name
}

# Diagnostic Settings for the VM
resource "azurerm_monitor_diagnostic_setting" "vm_diagnostics" {
  name                            = "vm-diagnostic-settings"
  target_resource_id              = data.azurerm_linux_virtual_machine.example.id
  storage_account_id              = azurerm_storage_account.example.id

  logs {
    category = "AuditLogs"
    enabled  = true
  }

  logs {
    category = "VirtualMachineHost"
    enabled  = true
  }

  metrics {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 30
    }
  }
}


  


# Metric Alert for high CPU usage
resource "azurerm_monitor_metric_alert" "high_cpu_alert" {
  name                        = "high-cpu-usage-alert"
  resource_group_name         = azurerm_resource_group.example.name
  location                    = azurerm_resource_group.example.location
  criteria {
    metric_name               = "Percentage CPU"
    aggregation               = "Average"
    operator                  = "GreaterThan"
    threshold                 = 80  # Trigger if CPU usage > 80%
    time_grain                = "PT1M"
    time_window               = "PT5M"
  }

  action {
    action_group_id           = azurerm_monitor_action_group.example.id
  }

  severity                   = 2  # Informational level
}
