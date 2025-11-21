# Bastion Outputs
output "bastion_id" {
  description = "The ID of the Azure Bastion Host"
  value       = azurerm_bastion_host.hub_bastion.id
}

output "bastion_name" {
  description = "The name of the Azure Bastion Host"
  value       = azurerm_bastion_host.hub_bastion.name
}

output "bastion_public_ip" {
  description = "The public IP address of the Azure Bastion Host"
  value       = azurerm_public_ip.bastion_pip.ip_address
}

# NAT Gateway Outputs
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.nat_gateway.id
}

output "nat_gateway_name" {
  description = "The name of the NAT Gateway"
  value       = azurerm_nat_gateway.nat_gateway.name
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = azurerm_public_ip.nat_gateway_pip.ip_address
}

# Application Gateway Outputs
output "appgw_id" {
  description = "The ID of the Application Gateway"
  value       = azurerm_application_gateway.appgw.id
}

output "appgw_name" {
  description = "The name of the Application Gateway"
  value       = azurerm_application_gateway.appgw.name
}

output "appgw_public_ip" {
  description = "The public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw_pip.ip_address
}

output "appgw_backend_pool_id" {
  description = "The ID of the Application Gateway backend pool"
  value       = tolist(azurerm_application_gateway.appgw.backend_address_pool)[0].id
}

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

