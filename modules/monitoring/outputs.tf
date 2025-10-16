output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.workspace_id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.name
}

output "log_analytics_worspace_resource_id" {
  description = "The resource ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.id
}

output "network_watcher_id" {
  description = "The ID of the Network Watcher"
  value       = azurerm_network_watcher.main.id
}
