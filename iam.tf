module "kv" {
  source              = "./modules/kv/"
  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location
  prefix              = var.prefix
  project_name        = var.project_name
  environment         = var.environment

  tags = local.common_tags
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_key_vault_secret" "ssh_public_key" {
  key_vault_id = module.kv.id
  name         = "ssh-public"
  value        = tls_private_key.main.public_key_openssh

  tags = local.common_tags
}

resource "azurerm_key_vault_secret" "ssh_private_key" {
  key_vault_id = module.kv.id
  name         = "ssh-private"
  value        = tls_private_key.main.private_key_pem

  tags = local.common_tags
}
