resource "random_string" "main" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_network_security_group" "nsg1" {
  name                = "${var.prefix}-${var.project_name}-nsg-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule = [
    {
      name                                       = "SSH"
      priority                                   = 1001
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "22"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "*"
      description                                = ""
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_ranges                    = []
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_ranges                         = []
    }
  ]
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.prefix}-${var.project_name}-vnet-${var.environment}"
  address_space       = var.address_space
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

resource "azurerm_subnet" "default" {
  name                 = "${var.prefix}-${var.project_name}-subnet-default-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [cidrsubnet(tolist(azurerm_virtual_network.vnet1.address_space)[0], 8, 1)]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [cidrsubnet(tolist(azurerm_virtual_network.vnet1.address_space)[0], 10, 8)]
}

resource "azurerm_subnet_network_security_group_association" "default_rule1" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
