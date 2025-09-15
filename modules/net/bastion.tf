resource "azurerm_public_ip" "bastion_pip" {
  name                = "${var.prefix}-${var.project_name}-bastion-pip-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_bastion_host" "bastion" {
  name                = "${var.prefix}-${var.project_name}-bastion-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  # dns_name            = "${var.prefix}-${var.project_name}-bastion-${var.environment}"
  sku = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = var.tags
}
