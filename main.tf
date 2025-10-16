# Terraform configuration file for deploying a Linux VM in Azure with networking, key vault and monitoring

# Local variables
locals {

  #Reusable tags for all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Version     = var.env_version
  }
}


# Create a single Azure resource group for simplicity
resource "azurerm_resource_group" "tflab_linux" {
  name     = "${var.prefix}-${var.project_name}-rg-${var.environment}"
  location = var.location

  tags = local.common_tags
}


# Building the network
module "network" {
  source              = "./modules/net/"
  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location
  prefix              = var.prefix
  project_name        = var.project_name
  environment         = var.environment
  address_space       = ["10.0.0.0/16"]

  tags = local.common_tags
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
  subnet_id             = module.network.subnet_id
  ssh_public_key        = azurerm_key_vault_secret.ssh_public_key.value # Fetch the public key from Key Vault
  appgw_backend_pool_id = module.network.appgw_backend_pool_id

  tags = local.common_tags
}


# Configure monitoring with Log Analytics and Network Watcher
module "mon" {
  source              = "./modules/monitoring/"
  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location
  prefix              = var.prefix
  project_name        = var.project_name
  environment         = var.environment
  vnet_id             = module.network.vnet_id

  tags = local.common_tags
}
