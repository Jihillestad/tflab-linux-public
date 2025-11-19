# Compute Module

## Description

Creates network interface and public IP for Azure VM connectivity.

## Usage

```hcl
module "compute" {
  source              = "./modules/compute/"
  resource_group_name = azurerm_resource_group.main.name
  location            = "norwayeast"
  prefix              = "myorg"
  project_name        = "webapp"
  environment         = "dev"
  subnet_id           = module.network.subnet_id
  tags                = local.common_tags
}
```

## Reqirements

| Name                                                                            | Version   |
| ------------------------------------------------------------------------------- | --------- |
| <a href="https://registry.terraform.io/providers/hashicorp/azurerm">azurerm</a> | >= 4.44.0 |
| <a href="https://registry.terraform.io/providers/hashicorp/random">random</a>   | >= 3.7.2  |

## Resources Created

- azurerm_public_ip
- azurerm_network_interface

## Inputs

| Name                        | Description                                                                                                      | Type          | Default           | Required |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------- | ----------------- | -------- |
| resource_group_name         | (Required) The name of the resource group in which to create the resources.                                      | `string`      | n/a               | yes      |
| location                    | (Required) The Azure region where resources will be created.                                                     | `string`      | n/a               | yes      |
| prefix                      | (Required) Prefix for resource names.                                                                            | `string`      | n/a               | yes      |
| project_name                | (Required) Project name for resource names.                                                                      | `string`      | n/a               | yes      |
| username                    | (Optional) Username for the VM.                                                                                  | `string`      | n/a               | no       |
| vm_image                    | (Optional) The VM Image to use.                                                                                  | `object()`    | n/a               | no       |
| sa_account_tier             | (Optional) The Tier of the Storage Account. Possible values are: Standard, Premium.                              | `string`      | `"Standard"`      | no       |
| sa_account_kind             | (Optional) The Kind of the Storage Account. Possible values are: Storage, StorageV2.                             | `string`      | `"StorageV2"`     | no       |
| sa_account_replication_type | (Optional) The Replication type of the Storage Account. Possible values are: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS. | `string`      | `"LRS"`           | no       |
| size                        | (Optional) Size of the VM.                                                                                       | `string`      | `Standard_DS1_v2` | no       |
| environment                 | (Required) Environment name for resource names.                                                                  | `string`      | n/a               | yes      |
| subnet_id                   | (Required) The ID of the Subnet to which the network interface will be connected.                                | `string`      | n/a               | yes      |
| ssh_public_key              | (Optional) SSH Public Key for Linux VM authentication.                                                           | `string`      |                   | yes      |
| tags                        | (Optional) A mapping of tags to assign to the resource.                                                          | `map(string)` | `{}`              | no       |

## Outputs

| Name                  | Description                                |
| --------------------- | ------------------------------------------ |
| inet_access_public_ip | The Public IP address for internet access. |
| inet_nic_id           | The ID of the Network Interface.           |
