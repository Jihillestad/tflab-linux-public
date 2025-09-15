locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Version     = var.env_version
  }
}

resource "azurerm_resource_group" "tflab_linux" {
  name     = "${var.prefix}-${var.project_name}-rg-${var.environment}"
  location = var.location

  tags = local.common_tags
}

module "network" {
  source              = "./modules/net/"
  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location
  prefix              = var.prefix
  project_name        = var.project_name
  environment         = var.environment
  address_space       = ["10.0.0.0/16"]
  law_id              = azurerm_log_analytics_workspace.law.id
  law_workspace_id    = azurerm_log_analytics_workspace.law.workspace_id
  law_region          = azurerm_log_analytics_workspace.law.location

  tags = local.common_tags
}

module "nic_linux" {
  source              = "./modules/compute/"
  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location
  prefix              = var.prefix
  project_name        = var.project_name
  environment         = var.environment
  subnet_id           = module.network.subnet_id

  tags = local.common_tags
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-${var.project_name}-law-${var.environment}"
  location            = azurerm_resource_group.tflab_linux.location
  resource_group_name = azurerm_resource_group.tflab_linux.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.common_tags
}
