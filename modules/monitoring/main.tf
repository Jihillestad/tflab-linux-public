# Description: This Terraform configuration sets up Azure Network Watcher with Flow Logs and Traffic Analytics for a specified Virtual Network.


# Create unique suffix for storage account name
resource "random_string" "main" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}


# Create a Log Analytics Workspace for monitoring
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-${var.project_name}-law-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# Create Network Watcher
resource "azurerm_network_watcher" "main" {
  name                = "${var.prefix}-${var.project_name}-nw-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}


# Create a Storage Account for Network Watcher Flow Logs
resource "azurerm_storage_account" "nw_sa" {
  # Storage account names must be globally unique and between 3-24 characters
  name                = substr(lower("${var.prefix}${var.project_name}nwsa${random_string.main.result}"), 0, 24) # Storage account names must be globally unique and between 3-24 characters. Overflow handled by substr function.
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier               = var.sa_account_tier
  account_kind               = var.sa_account_kind
  account_replication_type   = var.sa_account_replication_type
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2" # Enforce TLS 1.2 for security compliance
}


# Enable Network Watcher Flow Logs with Traffic Analytics
resource "azurerm_network_watcher_flow_log" "main" {
  network_watcher_name = azurerm_network_watcher.main.name
  resource_group_name  = var.resource_group_name
  name                 = "${var.prefix}-${var.project_name}-nw-fl-${var.environment}"
  location             = var.location

  target_resource_id = var.vnet_id # ID of the Virtual Network to monitor
  storage_account_id = azurerm_storage_account.nw_sa.id
  enabled            = true

  retention_policy {
    days    = var.vnet_flow_log_retention_days
    enabled = true
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.law.workspace_id # Link to the created Log Analytics Workspace
    workspace_region      = azurerm_log_analytics_workspace.law.location     # Link to the created Log Analytics Workspace
    workspace_resource_id = azurerm_log_analytics_workspace.law.id           # Link to the created Log Analytics Workspace
    interval_in_minutes   = 10
  }

  tags = var.tags

}
