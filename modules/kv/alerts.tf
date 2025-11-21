resource "azurerm_monitor_diagnostic_setting" "kv_diagnostics" {
  name                       = "${var.prefix}-${var.project_name}-kv-diagnostics"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_resource_id

  enabled_log {
    category = "AuditEvent" // Track secret access
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
