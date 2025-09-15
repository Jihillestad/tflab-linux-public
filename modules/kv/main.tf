data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                     = "${var.prefix}-${var.project_name}-kv-${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false

  sku_name = "standard"

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "terraform-sp" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
}
