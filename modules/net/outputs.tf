output "vnet_id" {
  description = "The ID of the created virtual network"
  value       = azurerm_virtual_network.vnet1.id
}

output "vnet_name" {
  description = "The name of the created virtual network"
  value       = azurerm_virtual_network.vnet1.name
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

# Bastion Host Outputs  
output "bastion_host_id" {
  description = "The ID of the created Bastion host"
  value       = azurerm_bastion_host.bastion.id
}

output "bastion_host_name" {
  description = "The name of the created Bastion host"
  value       = azurerm_bastion_host.bastion.name
}

output "bastion_public_ip" {
  description = "The public IP address of the Bastion host"
  value       = azurerm_public_ip.bastion_pip.ip_address
}

# NAT Gateway Outputs
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.nat_gateway.id
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

output "appgw_subnet_id" {
  description = "The ID of the Application Gateway subnet"
  value       = azurerm_subnet.this["appgw_subnet"].id
}

# NSG Outputs
output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.nsg1.id
}
