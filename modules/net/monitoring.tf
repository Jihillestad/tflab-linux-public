resource "azurerm_network_watcher" "main" {
  name                = "${var.prefix}-${var.project_name}-nw-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_storage_account" "nw_sa" {
  name                = "${var.prefix}${var.project_name}nwsa${random_string.main.result}"
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier               = "Standard"
  account_kind               = "StorageV2"
  account_replication_type   = "LRS"
  https_traffic_only_enabled = true
}

resource "azurerm_network_watcher_flow_log" "main" {
  network_watcher_name = azurerm_network_watcher.main.name
  resource_group_name  = var.resource_group_name
  name                 = "${var.prefix}-${var.project_name}-nw-fl-${var.environment}"
  location             = var.location

  target_resource_id = azurerm_virtual_network.vnet1.id
  storage_account_id = azurerm_storage_account.nw_sa.id
  enabled            = true
  retention_policy {
    days    = 7
    enabled = true
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.law_workspace_id
    workspace_region      = var.law_region
    workspace_resource_id = var.law_id
    interval_in_minutes   = 10
  }

}
