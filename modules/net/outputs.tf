output "vnet_id" {
  description = "The ID of the created virtual network"
  value       = azurerm_virtual_network.vnet1.id
}

output "subnet_id" {
  description = "The ID of the created subnet"
  value       = azurerm_subnet.default.id
}

output "subnet_name" {
  description = "The name of the created subnet"
  value       = azurerm_subnet.default.name
}

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

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.nat_gateway.id
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = azurerm_public_ip.nat_gateway_pip.ip_address
}

output "appgw_id" {
  description = "The ID of the Application Gateway"
  value       = azurerm_application_gateway.appgw.id
}

output "appgw_public_ip" {
  description = "The public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw_pip.ip_address
}

output "appgw_backend_pool_id" {
  description = "The ID of the Application Gateway backend pool"
  value       = tolist(azurerm_application_gateway.appgw.backend_address_pool)[0].id
}
