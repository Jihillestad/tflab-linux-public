resource "azurerm_public_ip" "inet_access" {
  name                = "${var.prefix}-${var.project_name}-inet-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_network_interface" "inet_nic" {
  name                = "${var.prefix}-${var.project_name}-inet-nic-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "connectivity"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.inet_access.id
  }

  tags = var.tags
}
