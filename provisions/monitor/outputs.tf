output "vm_diagnostic_setting_id" {
  value = azurerm_monitor_diagnostic_setting.vm_diagnostics.id
}

output "cpu_alert_id" {
  value = azurerm_monitor_metric_alert.high_cpu_alert.id
}

output "action_group_id" {
  value = azurerm_monitor_action_group.example.id
}
