# Description: This file contains the configuration for the Azure Bastion Host.
# It creates a dedicated subnet for the Bastion Host, a public IP address, and the
# Bastion Host itself. The Bastion Host allows secure RDP and SSH access to VMs
# in the virtual network without exposing them to the public internet


# Public IP for Bastion

resource "azurerm_public_ip" "bastion_pip" {
  name                = "${var.prefix}-${var.project_name}-bastion-pip-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}


# Bastion Host

resource "azurerm_bastion_host" "bastion" {
  name                = "${var.prefix}-${var.project_name}-bastion-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  # dns_name            = "${var.prefix}-${var.project_name}-bastion-${var.environment}"
  sku = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.this["bastion_subnet"].id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = var.tags
}
