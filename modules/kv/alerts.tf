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

# Alert for high API latency
resource "azurerm_monitor_metric_alert" "kv_latency" {
  name                = "${var.prefix}-${var.project_name}-kv-latency-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_key_vault.main.id]
  description         = "Alert when Key Vault API latency is too high"
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "ServiceApiLatency"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 1000  # 1 second
  }

  action {
    action_group_id = azurerm_monitor_action_group.kv_alerts.id
  }

  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Alert for failed API calls
resource "azurerm_monitor_metric_alert" "kv_failed_requests" {
  name                = "${var.prefix}-${var.project_name}-kv-failed-requests-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_key_vault.main.id]
  description         = "Alert when Key Vault has failed API requests"
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "ServiceApiResult"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 10
  }

  action {
    action_group_id = azurerm_monitor_action_group.kv_alerts.id
  }

  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}
```

---

## 📈 Version Progression Analysis
```
v3.0.0 (Major)  → Monitoring refactoring         [A+ 100%]
v3.1.0 (Minor)  → Added KV, Bastion, NAT monitoring [A  97%]
v3.1.1 (Patch)  → More alerts + CAF naming       [A+ 99%]
