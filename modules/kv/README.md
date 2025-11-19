# Key Vault Module

## Disclaimer

This module is intended for lab use and may not adhere to production best
practices. If adding secrets to the key vault with Terraform, be aware that the
secrets will be stored in the Terraform state file in plain text. Exercise
caution when using this module in production environments.

## Description

Creates an Azure Key Vault with necessary configurations.

## Usage

```hcl

module "kv" {
  source              = "./modules/kv/"
  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location
  prefix              = var.prefix
  project_name        = var.project_name
  environment         = var.environment
  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  tags = local.common_tags
}
```

## Reqirements

| Name                                                                            | Version   |
| ------------------------------------------------------------------------------- | --------- |
| <a href="https://registry.terraform.io/providers/hashicorp/azurerm">azurerm</a> | >= 4.44.0 |
| <a href="https://registry.terraform.io/providers/hashicorp/random">random</a>   | >= 3.7.2  |

## Resources Created

- azurerm_key_vault
- azurerm_key_vault_access_policy

## Inputs

| Name                       | Description                                                                 | Type          | Default | Required |
| -------------------------- | --------------------------------------------------------------------------- | ------------- | ------- | -------- |
| resource_group_name        | (Required) The name of the resource group in which to create the resources. | `string`      | n/a     | yes      |
| location                   | (Required) The Azure region where resources will be created.                | `string`      | n/a     | yes      |
| prefix                     | (Required) Prefix for resource names.                                       | `string`      | n/a     | yes      |
| project_name               | (Required) Project name for resource names.                                 | `string`      | n/a     | yes      |
| environment                | (Required) Environment name for resource names.                             | `string`      | n/a     | yes      |
| purge_protection_enabled   | (Optional) Enable purge protection for the Key Vault.                       | `bool`        | `false` | no       |
| soft_delete_retention_days | (Optional) Number of days to retain deleted Key Vaults.                     | `number`      | `7`     | no       |
| tags                       | (Optional) A mapping of tags to assign to the resource.                     | `map(string)` | `{}`    | no       |

## Outputs

| Name   | Description               |
| ------ | ------------------------- |
| kv_id  | The ID of the Key Vault.  |
| kv_uri | The URI of the Key Vault. |
