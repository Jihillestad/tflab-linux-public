# Terraform configuration file for deploying a Linux VM in Azure with networking, key vault and monitoring

# Local variables
locals {

  #Reusable tags for all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Version     = var.env_version
  }

  # Hub VNet configuration
  hub_vnet = {
    name          = "${var.prefix}-${var.project_name}-vnet-hub-${var.environment}"
    address_space = ["10.0.0.0/16"]

    subnets = {
      default = {
        name         = "default"
        cidr_newbits = 8
        cidr_netnum  = 1
        nsg_enabled  = true
      }
      appgw_subnet = {
        name         = "appgw"
        cidr_newbits = 8
        cidr_netnum  = 2
        nsg_enabled  = false
      }
      bastion_subnet = {
        name         = "bastion"
        cidr_newbits = 10
        cidr_netnum  = 12
        nsg_enabled  = false
      }
    }
  }
}


# Create a single Azure resource group for simplicity
resource "azurerm_resource_group" "tflab_linux" {
  name     = "${var.prefix}-${var.project_name}-rg-${var.environment}"
  location = var.location

  tags = local.common_tags
}


# Building the network
module "hub_network" {
  source              = "./modules/net/"
  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location
  vnet_config         = local.hub_vnet

  tags = local.common_tags

  depends_on = [
    azurerm_resource_group_policy_assignment.allowed_locations,
    azurerm_resource_group_policy_assignment.require_environment_tag,
  ]
}

# Hub Services (Bastion, NAT Gateway, App Gateway)
module "hub_services" {
  source = "./modules/hubserv/"

  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location
  prefix              = var.prefix
  project_name        = var.project_name
  environment         = var.environment

  # Subnet references from hub network module
  bastion_subnet_id = module.hub_network.subnet_ids["bastion_subnet"]
  appgw_subnet_id   = module.hub_network.subnet_ids["appgw_subnet"]

  # Subnets that should use NAT Gateway
  nat_gateway_subnets = {
    default = module.hub_network.subnet_ids["default"]
  }

  # Monitoring configuration
  admin_email = var.admin_email

  tags = local.common_tags

  depends_on = [
    azurerm_resource_group_policy_assignment.allowed_locations,
    azurerm_resource_group_policy_assignment.require_environment_tag,
  ]
}


# Create a network interface for the Linux VM with secure ingress/egress
module "vm" {
  source                = "./modules/compute/"
  resource_group_name   = azurerm_resource_group.tflab_linux.name
  location              = azurerm_resource_group.tflab_linux.location
  username              = var.username
  size                  = var.size
  prefix                = var.prefix
  project_name          = var.project_name
  environment           = var.environment
  subnet_id             = module.hub_network.subnet_ids["default"]
  ssh_public_key        = azurerm_key_vault_secret.ssh_public_key.value // Fetch the public key from Key Vault
  appgw_backend_pool_id = module.hub_services.appgw_backend_pool_id

  tags = local.common_tags

  depends_on = [
    azurerm_resource_group_policy_assignment.allowed_locations,
    azurerm_resource_group_policy_assignment.require_environment_tag,
  ]
}
