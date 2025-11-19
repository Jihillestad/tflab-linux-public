output "vnet_id" {
  description = "The ID of the created virtual network"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of the created virtual network"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    for key, subnet in azurerm_subnet.this : key => subnet.id
  }
}

output "subnet_names" {
  description = "Map of subnet keys to their names"
  value = {
    for key, subnet in azurerm_subnet.this : key => subnet.name
  }
}

# Legacy outputs for default subnet (Deprecated)
output "subnet_id" {
  description = "The ID of the created subnet (deprecated, use subnet_ids output instead)"
  value       = azurerm_subnet.this["default"].id
}

output "subnet_name" {
  description = "The name of the created subnet (deprecated, use subnet_names output instead)"
  value       = azurerm_subnet.this["default"].name
}

# NSG Outputs
output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.this.id
}
