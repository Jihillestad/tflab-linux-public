# Net Module

## Description

Creates an Azure network intended for Lab usage.

## Usage

```hcl

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
```

## Reqirements

| Name                                                                            | Version   |
| ------------------------------------------------------------------------------- | --------- |
| <a href="https://registry.terraform.io/providers/hashicorp/azurerm">azurerm</a> | >= 4.44.0 |
| <a href="https://registry.terraform.io/providers/hashicorp/random">random</a>   | >= 3.7.2  |

## Resources Created

- azurerm_network_security_group
- azurerm_virtual_network
- azurerm_subnet
  - default subnet
  - AzureBastionSubnet
- azurerm_subnet_network_security_group_association

## Inputs

| Name                         | Description                                                                                                      | Type           | Default       | Required |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------- | -------------- | ------------- | -------- |
| resource_group_name          | (Required) The name of the resource group in which to create the resources.                                      | `string`       | n/a           | yes      |
| location                     | (Required) The Azure region where resources will be created.                                                     | `string`       | n/a           | yes      |
| prefix                       | (Required) Prefix for resource names.                                                                            | `string`       | n/a           | yes      |
| project_name                 | (Required) Project name for resource names.                                                                      | `string`       | n/a           | yes      |
| environment                  | (Required) Environment name for resource names.                                                                  | `string`       | n/a           | yes      |
| address_space                | (Required) The address space that is used by the virtual network.                                                | `list(string)` | n/a           | yes      |
| sa_account_tier              | (Optional) The Tier of the Storage Account. Possible values are: Standard, Premium.                              | `string`       | `"Standard"`  | no       |
| sa_account_kind              | (Optional) The Kind of the Storage Account. Possible values are: Storage, StorageV2.                             | `string`       | `"StorageV2"` | no       |
| sa_account_replication_type  | (Optional) The Replication type of the Storage Account. Possible values are: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS. | `string`       | `"LRS"`       | no       |
| vnet_flow_log_retention_days | (Optional) The number of days to retain logs. Set to 0 for unlimited retention.                                  | `number`       | `7`           | no       |
| law_id                       | (Required) The ID of the Log Analytics Workspace to link to the NSG.                                             | `string`       | n/a           | yes      |
| law_workspace_id             | (Required) The Workspace ID of the Log Analytics Workspace to link to the NSG.                                   | `string`       | n/a           | yes      |
| law_region                   | (Required) The region of the Log Analytics Workspace to link to the NSG.                                         | `string`       | n/a           | yes      |
| tags                         | (Optional) A mapping of tags to assign to the resource.                                                          | `map(string)`  | `{}`          | no       |

## Outputs

| Name                    | Description                                     |
| ----------------------- | ----------------------------------------------- |
| vnet_id                 | The ID of the Virtual Network.                  |
| subnet_id(deprecated)   | The ID of the default Subnet.                   |
| subnet_ids              | The IDs of the default Subnets.                 |
| subnet_name(deprecated) | The name of the default Subnet.                 |
| subnet_names            | The names of the default Subnets.               |
| bastion_host_id         | The ID of the Azure Bastion Host.               |
| bastion_host_name       | The name of the Azure Bastion Host.             |
| bastion_public_ip       | The public IP of the Azure Bastion Host.        |
| nat_gateway_id          | The ID of the NAT Gateway.                      |
| nat_gateway_public_ip   | The public IP of the NAT Gateway.               |
| appgw_id                | The ID of the Application Gateway.              |
| appgw_name              | The name of the Application Gateway.            |
| appgw_public_ip         | The public IP of the Application Gateway.       |
| appgw_backend_pool_id   | The ID of the Application Gateway backend pool. |
| appgw_subnet_id         | The ID of the Application Gateway subnet.       |
| nsg_id                  | The ID of the Network Security Group.           |
