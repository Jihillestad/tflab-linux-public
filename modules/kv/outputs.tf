output "kv_id" {
  value = azurerm_key_vault_access_policy.terraform-sp.key_vault_id
}

output "kv_uri" {
  value = azurerm_key_vault.main.vault_uri
}
