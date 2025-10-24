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
