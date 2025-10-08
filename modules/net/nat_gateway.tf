# Description: This file contains the configuration for Azure NAT Gateway.
# NAT Gateway provides secure outbound internet connectivity for resources
# in the virtual network without exposing them via public IPs.


# Public IP for NAT Gateway

resource "azurerm_public_ip" "nat_gateway_pip" {
  name                = "${var.prefix}-${var.project_name}-nat-pip-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}


# NAT Gateway

resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = "${var.prefix}-${var.project_name}-nat-gateway-${var.environment}"
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10

  tags = var.tags
}


# Associate Public IP with NAT Gateway

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_pip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gateway_pip.id
}


# Associate NAT Gateway with Default Subnet

resource "azurerm_subnet_nat_gateway_association" "default_subnet_nat" {
  subnet_id      = azurerm_subnet.default.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
