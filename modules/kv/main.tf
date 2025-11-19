# Description: Terraform configuration for creating an Azure Key Vault and setting access policies


# Fetch current Azure client configuration
data "azurerm_client_config" "current" {}


# Create the Key Vault
resource "azurerm_key_vault" "main" {
  name                       = "${var.prefix}-${var.project_name}-kv-${var.environment}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  sku_name = "standard"

  tags = var.tags
}


# Set access policy for the current user/service principal to manage secrets
resource "azurerm_key_vault_access_policy" "terraform-sp" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
}
