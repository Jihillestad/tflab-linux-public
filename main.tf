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

  # TODO: Refactor Log Analytics to its own monitoring module
  law_id           = azurerm_log_analytics_workspace.law.id
  law_workspace_id = azurerm_log_analytics_workspace.law.workspace_id
  law_region       = azurerm_log_analytics_workspace.law.location

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


# Create a Log Analytics Workspace for monitoring
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-${var.project_name}-law-${var.environment}"
  location            = azurerm_resource_group.tflab_linux.location
  resource_group_name = azurerm_resource_group.tflab_linux.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.common_tags
}
