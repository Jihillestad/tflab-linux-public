# Description: This Terraform configuration creates a public IP address and a network interface in Azure.
# The public IP address is statically allocated and uses the Standard SKU. The network interface is
# associated with the public IP address and is configured to use a specified subnet.
# In future version tags, I'll automate the creation of Compute resources.


# Public IP for internet access

resource "azurerm_public_ip" "inet_access" {
  name                = "${var.prefix}-${var.project_name}-inet-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}


# Network Interface for Compute resources

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
