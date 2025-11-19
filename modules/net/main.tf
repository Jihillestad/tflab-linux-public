# Description: This Terraform configuration creates an Azure Virtual Network
# with subnets and a Network Security Group (NSG) with a rule to allow SSH
# access.

locals {

  # Define subnets with dynamic address prefixes based on VNet address space
  subnet_config = var.vnet_config.subnets

  # Generate subnet configurations
  subnets = {
    for key, config in local.subnet_config : key => {
      name   = config.name == "bastion" ? "AzureBastionSubnet" : "${var.vnet_config.name}-subnet-${config.name}"
      prefix = cidrsubnet(var.vnet_config.address_space[0], config.cidr_newbits, config.cidr_netnum)
    }
  }
  # Helper maps for associations
  subnets_with_nsg = {
    for key, config in local.subnet_config : key => config if config.nsg_enabled
  }
}


#Build the NSG with a rule to allow SSH
resource "azurerm_network_security_group" "this" {
  name                = "${var.vnet_config.name}-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

# NSG Rule: Allow SSH from Bastion subnet
resource "azurerm_network_security_rule" "allow_ssh_from_bastion" {
  name                        = "AllowSSHFromBastion"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = azurerm_subnet.this["bastion_subnet"].address_prefixes
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
  description                 = "Allow SSH access from Azure Bastion subnet"
}

# Associate NSG with subnets that have nsg_enabled = true
resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each = local.subnets_with_nsg

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg1.id // When more nsg's are needed, add the correct nsg as a key in the local.subnet_config
}

#Build the VNet and subnets
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_config.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.vnet_config.address_space

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = local.subnets

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.prefix]
}
