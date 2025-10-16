output "log_analytics_workspace_id" {
  description = "The workspace ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.workspace_id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.name
}

output "log_analytics_workspace_resource_id" {
  description = "The resource ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.id
}

output "log_analytics_workspace_location" {
  description = "The location of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.location
}

output "network_watcher_id" {
  description = "The ID of the Network Watcher"
  value       = azurerm_network_watcher.main.id
}

output "network_watcher_name" {
  description = "The name of the Network Watcher"
  value       = azurerm_network_watcher.main.name
}

output "storage_account_id" {
  description = "The ID of the storage account for flow logs"
  value       = azurerm_storage_account.nw_sa.id
}
