# Description: This Terraform configuration creates an Azure Virtual Network
# with subnets and a Network Security Group (NSG) with a rule to allow SSH
# access.

locals {

  # Define subnets with dynamic address prefixes based on VNet address space
  subnet_config = {
    default = {
      name         = "default"
      cidr_newbits = 8
      cidr_netnum  = 1
      nsg_enabled  = true
      nat_enabled  = true
    }
    appgw_subnet = {
      name         = "appgw"
      cidr_newbits = 8
      cidr_netnum  = 2
      nsg_enabled  = false
      nat_enabled  = false
    }
    bastion_subnet = {
      name         = "bastion"
      cidr_newbits = 10
      cidr_netnum  = 12
      nsg_enabled  = false
      nat_enabled  = false
    }
  }

  # Generate subnet configurations
  subnets = {
    for key, config in local.subnet_config : key => {
      name   = config.name == "bastion" ? "AzureBastionSubnet" : "${var.prefix}-${var.project_name}-subnet-${config.name}-${var.environment}"
      prefix = cidrsubnet(tolist(azurerm_virtual_network.vnet1.address_space)[0], config.cidr_newbits, config.cidr_netnum)
    }
  }
}


#Build the NSG with a rule to allow SSH
resource "azurerm_network_security_group" "nsg1" {
  name                = "${var.prefix}-${var.project_name}-nsg-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location

  # Allow SSH from Bastion subnet
  security_rule = [
    {
      name                                       = "SSH"
      priority                                   = 1001
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "22"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      description                                = ""
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_ranges                    = []
      source_address_prefixes                    = azurerm_subnet.this["bastion_subnet"].address_prefixes
      source_application_security_group_ids      = []
      source_port_ranges                         = []
    },
  ]
}


#Build the VNet and subnets
resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.prefix}-${var.project_name}-vnet-${var.environment}"
  address_space       = var.address_space
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = local.subnets

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [each.value.prefix]
}


# Associate NSG with Default Subnet
resource "azurerm_subnet_network_security_group_association" "default_rule1" {
  subnet_id                 = azurerm_subnet.this["default"].id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
