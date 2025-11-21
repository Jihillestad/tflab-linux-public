resource "azurerm_monitor_diagnostic_setting" "kv_diagnostics" {
  name                       = "${var.prefix}-${var.project_name}-kv-diagnostics-${var.environment}"
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

# Action Group for Application Gateway Alerts
resource "azurerm_monitor_action_group" "kv_alerts" {
  name                = "${var.prefix}-${var.project_name}-kv-action-group-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = "kvalerts"

  email_receiver {
    name          = "send-to-admin"
    email_address = var.admin_email
  }

  # Optional: Add SMS
  # sms_receiver {
  #   name         = "send-sms"
  #   country_code = "47"
  #   phone_number = "12345678"
  # }

  tags = var.tags
}

# Alert for Key Vault availability
resource "azurerm_monitor_metric_alert" "kv_availability" {
  name                = "${var.prefix}-${var.project_name}-kv-availability-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_key_vault.main.id]
  description         = "Alert when Key Vault availability drops"
  severity            = 1 # Critical

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "Availability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 99 # 99% availability threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.kv_alerts.id
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  tags = var.tags
}
