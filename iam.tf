# Description: This file contains the resources for IAM, including Key Vault and SSH key pair generation.
# DANGER: The secrets are stored in Terraform state files in plain text. Ensure state files are securely managed.
# DO NOT use in production environments. This is for learning and testing purposes only. 
# In production environments, keey the secrets out of Terraform state.
# ------------------------------------------------------------------------------


# Create an Azure Key Vault 
module "kv" {
  source                     = "./modules/kv/"
  resource_group_name        = azurerm_resource_group.tflab_linux.name
  location                   = azurerm_resource_group.tflab_linux.location
  prefix                     = var.prefix
  project_name               = var.project_name
  environment                = var.environment
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  tags = local.common_tags

  depends_on = [
    azurerm_resource_group_policy_assignment.allowed_locations,
    azurerm_resource_group_policy_assignment.require_environment_tag,
  ]
}


# Generate an SSH key pair.
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


# Store the SSH keys in the Key Vault as secrets
resource "azurerm_key_vault_secret" "ssh_public_key" {
  key_vault_id = module.kv.kv_id
  name         = "ssh-public"
  value        = tls_private_key.main.public_key_openssh

  tags = local.common_tags
}

resource "azurerm_key_vault_secret" "ssh_private_key" {
  key_vault_id = module.kv.kv_id
  name         = "ssh-private"
  value        = tls_private_key.main.private_key_pem

  tags = local.common_tags
}
