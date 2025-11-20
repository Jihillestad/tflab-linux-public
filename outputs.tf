output "hub_rg_name" {
  description = "The name of the Hub Resource Group"
  value       = azurerm_resource_group.tflab_linux.name
}

output "hub_vnet_id" {
  description = "The ID of the Virtual Network"
  value       = module.hub_network.vnet_id
}

output "hub_vnet_name" {
  description = "The name of the Hub Virtual Network"
  value       = module.hub_network.vnet_name
}

output "policy_assignments" {
  description = "Applied policy assignment IDs"
  value = {
    allowed_locations       = azurerm_resource_group_policy_assignment.allowed_locations.id
    require_environment_tag = azurerm_resource_group_policy_assignment.require_environment_tag.id
  }
}
