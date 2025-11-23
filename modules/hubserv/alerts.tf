# --------------------------------------------------------------------------
# MONITORING FOR HUB SERVICES
# --------------------------------------------------------------------------


# ------------------------------------------------------------
# APPLICATION GATEWAY
# ------------------------------------------------------------

# Diagnostic Settings for Application Gateway
resource "azurerm_monitor_diagnostic_setting" "appgw_diagnostics" {
  name                       = "${var.prefix}-${var.project_name}-appgw-diagnostics-${var.environment}"
  target_resource_id         = azurerm_application_gateway.appgw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

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

# Action Group for Application Gateway Alerts
resource "azurerm_monitor_action_group" "appgw_alerts" {
  name                = "${var.prefix}-${var.project_name}-appgw-action-group-${var.environment}"
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
  name                = "${var.prefix}-${var.project_name}-appgw-unhealthy-host-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_gateway.appgw.id]
  description         = "Alert when Application Gateway has unhealthy backend hosts"
  severity            = 1 // Critical

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


  frequency   = "PT1M" // Check every 1 minute
  window_size = "PT5M" // Over 5 minute window

  tags = var.tags
}

# Alert for failed requests
resource "azurerm_monitor_metric_alert" "appgw_failed_requests" {
  name                = "${var.prefix}-${var.project_name}-appgw-failed-requests-alert-${var.environment}"
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

  frequency   = "PT5M"  // Check every 5 minutes
  window_size = "PT15M" // Over 15 minute window

  tags = var.tags
}

# Alert for backend response time
resource "azurerm_monitor_metric_alert" "appgw_backend_response_time" {
  name                = "${var.prefix}-${var.project_name}-appgw-response-time-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_gateway.appgw.id]
  description         = "Alert when backend response time is too high"
  severity            = 2 // Warning

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "BackendLastByteResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 5000 // 5 seconds
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
  name                = "${var.prefix}-${var.project_name}-appgw-5xx-errors-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_gateway.appgw.id]
  description         = "Alert when Application Gateway returns high 5xx errors"
  severity            = 1 // Critical

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

# Alert for 4xx errors (client errors)
resource "azurerm_monitor_metric_alert" "appgw_4xx_errors" {
  name                = "${var.prefix}-${var.project_name}-appgw-4xx-errors-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_gateway.appgw.id]
  description         = "Alert when Application Gateway returns high 4xx errors"
  severity            = 2 // Warning

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "ResponseStatus"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 100

    dimension {
      name     = "HttpStatusGroup"
      operator = "Include"
      values   = ["4xx"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.appgw_alerts.id
  }

  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Alert for compute unit usage (capacity planning)
resource "azurerm_monitor_metric_alert" "appgw_compute_units" {
  name                = "${var.prefix}-${var.project_name}-appgw-compute-units-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_gateway.appgw.id]
  description         = "Alert when Application Gateway compute units are high"
  severity            = 2 // Warning

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "ComputeUnits"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 8 // Out of 10 max for WAF_v2
  }

  action {
    action_group_id = azurerm_monitor_action_group.appgw_alerts.id
  }

  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Alert for capacity units (billing metric)
resource "azurerm_monitor_metric_alert" "appgw_capacity_units" {
  name                = "${var.prefix}-${var.project_name}-appgw-capacity-units-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_gateway.appgw.id]
  description         = "Alert when Application Gateway capacity units are high (cost)"
  severity            = 3 // Informational

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "CapacityUnits"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 5 // Alert before autoscaling triggers
  }

  action {
    action_group_id = azurerm_monitor_action_group.appgw_alerts.id
  }

  frequency   = "PT15M"
  window_size = "PT1H"

  tags = var.tags
}

# Add Application Insights for Application Gateway
resource "azurerm_application_insights" "appgw_insights" {
  name                = "${var.prefix}-${var.project_name}-appinsights-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.law.id

  tags = var.tags
}

# Random UID for Workbook naming
resource "random_uuid" "appgw_workbook_uuid" {}

# Workbook Dashboard for Application Gateway'
resource "azurerm_application_insights_workbook" "appgw_dashboard" {
  name                = random_uuid.appgw_workbook_uuid.result
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = "Application Gateway Monitoring Dashboard"

  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type = 3
        content = {
          version      = "KqlItem/1.0"
          query        = "AzureDiagnostics\n| where ResourceType == \"APPLICATIONGATEWAYS\"\n| summarize count() by bin(TimeGenerated, 5m)"
          size         = 0
          title        = "Application Gateway Requests"
          queryType    = 0
          resourceType = "microsoft.operationalinsights/workspaces"
        }
      }
    ]
  })

  tags = var.tags
}

# ------------------------------------------------------------
# BASTION HOST
# ------------------------------------------------------------

resource "azurerm_monitor_diagnostic_setting" "bastion_diagnostics" {
  name                       = "${var.prefix}-${var.project_name}-bastion-diagnostics-${var.environment}"
  target_resource_id         = azurerm_bastion_host.hub_bastion.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "BastionAuditLogs" // Who accessed what
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Action Group for Bastion Alerts
resource "azurerm_monitor_action_group" "bastion_alerts" {
  name                = "${var.prefix}-${var.project_name}-bastion-action-group-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = "bastionalert"

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

# Alert for high connection count (potential abuse)
resource "azurerm_monitor_metric_alert" "bastion_high_sessions" {
  name                = "${var.prefix}-${var.project_name}-bastion-high-sessions-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_bastion_host.hub_bastion.id]
  description         = "Alert when Bastion has unusually high session count"
  severity            = 2 // Warning

  criteria {
    metric_namespace = "Microsoft.Network/bastionHosts"
    metric_name      = "sessions"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 10 // Adjust based on your usage
  }

  action {
    action_group_id = azurerm_monitor_action_group.bastion_alerts.id
  }

  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# ------------------------------------------------------------
# NAT GATEWAY
# ------------------------------------------------------------

resource "azurerm_monitor_diagnostic_setting" "nat_gateway_diagnostics" {
  name                       = "${var.prefix}-${var.project_name}-natgw-diagnostics-${var.environment}"
  target_resource_id         = azurerm_nat_gateway.nat_gateway.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_metric {
    category = "AllMetrics"
  }
}

# Action Group for NAT Gateway Alerts
resource "azurerm_monitor_action_group" "natgw_alerts" {
  name                = "${var.prefix}-${var.project_name}-natgw-action-group-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = "natgwalert"

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

# Alert for SNAT port exhaustion
resource "azurerm_monitor_metric_alert" "natgw_snat_exhaustion" {
  name                = "${var.prefix}-${var.project_name}-natgw-snat-exhaustion-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_nat_gateway.nat_gateway.id]
  description         = "Alert when NAT Gateway is running out of SNAT ports"
  severity            = 1 // Critical

  criteria {
    metric_namespace = "Microsoft.Network/natGateways"
    metric_name      = "SNATConnectionCount"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50000 // 64K max, alert at 50K
  }

  action {
    action_group_id = azurerm_monitor_action_group.natgw_alerts.id
  }

  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}

# Alert for dropped packets
resource "azurerm_monitor_metric_alert" "natgw_dropped_packets" {
  name                = "${var.prefix}-${var.project_name}-natgw-dropped-packets-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_nat_gateway.nat_gateway.id]
  description         = "Alert when NAT Gateway is dropping packets"
  severity            = 2 // Warning

  criteria {
    metric_namespace = "Microsoft.Network/natGateways"
    metric_name      = "PacketDropCount"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 100
  }

  action {
    action_group_id = azurerm_monitor_action_group.natgw_alerts.id
  }

  frequency   = "PT5M"
  window_size = "PT15M"

  tags = var.tags
}
