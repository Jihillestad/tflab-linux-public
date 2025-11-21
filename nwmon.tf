# -----------------------------------------------------------------------------
# Network Watcher Monitoring Configuration for Flow Logs with Traffic Analytics
# -----------------------------------------------------------------------------

# Create unique suffix for storage account name
resource "random_string" "main" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

locals {
  # Calculate components separately for clarity
  storage_prefix = lower("${var.prefix}${var.project_name}nwsa")
  storage_suffix = random_string.main.result

  # Total length will be prefix + suffix
  storage_name_length = length(local.storage_prefix) + length(local.storage_suffix)
}


# Data source to get existing Network Watcher in the specified location
data "azurerm_network_watcher" "main" {
  name                = "NetworkWatcher_${var.location}"
  resource_group_name = "NetworkWatcherRG"
}

# Create a Storage Account for Network Watcher Flow Logs
resource "azurerm_storage_account" "nw_sa" {
  name                = "${local.storage_prefix}${local.storage_suffix}"
  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location

  account_tier               = var.sa_account_tier
  account_kind               = var.sa_account_kind
  account_replication_type   = var.sa_account_replication_type
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2" // Enforce TLS 1.2 for security compliance

  # Overflow protection for storage account name length
  lifecycle {
    precondition {
      condition     = local.storage_name_length <= 24
      error_message = "Storage account name would exceed 24 characters: ${local.storage_name_length}"
    }
  }

  tags = local.common_tags
}

# Enable Network Watcher Flow Logs with Traffic Analytics
resource "azurerm_network_watcher_flow_log" "main" {
  network_watcher_name = data.azurerm_network_watcher.main.name
  resource_group_name  = data.azurerm_network_watcher.main.resource_group_name
  name                 = "${var.prefix}-${var.project_name}-nw-fl-${var.environment}"
  location             = var.location

  target_resource_id = module.hub_network.vnet_id // Apply flow logs to the created VNet in hub network module
  storage_account_id = azurerm_storage_account.nw_sa.id
  enabled            = true

  retention_policy {
    days    = var.vnet_flow_log_retention_days
    enabled = true
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = module.hub_services.log_analytics_workspace_id
    workspace_region      = module.hub_services.log_analytics_workspace_location
    workspace_resource_id = module.hub_services.log_analytics_workspace_resource_id
    interval_in_minutes   = 10
  }

  tags = local.common_tags
}
