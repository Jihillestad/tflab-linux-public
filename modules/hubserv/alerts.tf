# --------------------------------------------------------------------------
# MONITORING FOR HUB SERVICES
# --------------------------------------------------------------------------


# ------------------------------------------------------------
# APPLICATION GATEWAY
# ------------------------------------------------------------

# Diagnostic Settings for Application Gateway
resource "azurerm_monitor_diagnostic_setting" "appgw_diagnostics" {
  name                       = "${var.hub_vnet_name}-appgw-diagnostics"
  target_resource_id         = azurerm_application_gateway.appgw.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Application Gateway Logs
  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  # Application Gateway Metrics
  enabled_metric {
    category = "AllMetrics"
  }
}

# Action Group for Alerts
resource "azurerm_monitor_action_group" "appgw_alerts" {
  name                = "${var.hub_vnet_name}-appgw-action-group"
  resource_group_name = var.resource_group_name
  short_name          = "appgwalert"

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

# Alert for unhealthy backends
resource "azurerm_monitor_metric_alert" "appgw_unhealthy_host" {
  name                = "${var.hub_vnet_name}-appgw-unhealthy-host-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_gateway.appgw.id]
  description         = "Alert when Application Gateway has unhealthy backend hosts"
  severity            = 1 # Critical

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "UnhealthyHostCount"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0
  }

  action {
    action_group_id = azurerm_monitor_action_group.appgw_alerts.id
  }


  frequency   = "PT1M" # Check every 1 minute
  window_size = "PT5M" # Over 5 minute window

  tags = var.tags
}

# Alert for failed requests
resource "azurerm_monitor_metric_alert" "appgw_failed_requests" {
  name                = "${var.hub_vnet_name}-appgw-failed-requests-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_gateway.appgw.id]
  description         = "Alert when Application Gateway has high failed request rate"
  severity            = 2 # Warning

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "FailedRequests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 100
  }


  action {
    action_group_id = azurerm_monitor_action_group.appgw_alerts.id
  }

  frequency   = "PT5M"  # Check every 5 minutes
  window_size = "PT15M" # Over 15 minute window

  tags = var.tags
}

# Alert for backend response time
resource "azurerm_monitor_metric_alert" "appgw_backend_response_time" {
  name                = "${var.hub_vnet_name}-appgw-response-time-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_gateway.appgw.id]
  description         = "Alert when backend response time is too high"
  severity            = 2 # Warning

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "BackendLastByteResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 5000 # 5 seconds
  }

  action {
    action_group_id = azurerm_monitor_action_group.appgw_alerts.id
  }

  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Alert for high 5xx errors
resource "azurerm_monitor_metric_alert" "appgw_5xx_errors" {
  name                = "${var.hub_vnet_name}-appgw-5xx-errors-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_gateway.appgw.id]
  description         = "Alert when Application Gateway returns high 5xx errors"
  severity            = 1 # Critical

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "ResponseStatus"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50

    dimension {
      name     = "HttpStatusGroup"
      operator = "Include"
      values   = ["5xx"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.appgw_alerts.id
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  tags = var.tags
}
