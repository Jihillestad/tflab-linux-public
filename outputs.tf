output "hub_rg_name" {
  description = "The name of the Hub Resource Group"
  value       = azurerm_resource_group.tflab_linux.name
}

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = module.hub_network.vnet_id
}
