# Key Vault Module

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

| Name                | Description                                                                 | Type          | Default | Required |
| ------------------- | --------------------------------------------------------------------------- | ------------- | ------- | -------- |
| resource_group_name | (Required) The name of the resource group in which to create the resources. | `string`      | n/a     | yes      |
| location            | (Required) The Azure region where resources will be created.                | `string`      | n/a     | yes      |
| prefix              | (Required) Prefix for resource names.                                       | `string`      | n/a     | yes      |
| project_name        | (Required) Project name for resource names.                                 | `string`      | n/a     | yes      |
| environment         | (Required) Environment name for resource names.                             | `string`      | n/a     | yes      |
| tags                | (Optional) A mapping of tags to assign to the resource.                     | `map(string)` | `{}`    | no       |

## Outputs

| Name   | Description               |
| ------ | ------------------------- |
| kv_id  | The ID of the Key Vault.  |
| kv_uri | The URI of the Key Vault. |
