# Net Module

## Description

Creates an Azure network intended for Lab usage.

## Usage

Pass a map of objects defining the vnet and subnets.

```hcl
locals {
  hub_vnet = {
    name          = "${var.prefix}-${var.project_name}-vnet-hub-${var.environment}"
    address_space = ["10.0.0.0/16"]

    subnets = {
      default = {
        name         = "default"
        cidr_newbits = 8
        cidr_netnum  = 1
        nsg_enabled  = true
        nat_enabled  = true
      }
      appgw_subnet = {
        name         = "appgw"
        cidr_newbits = 8
        cidr_netnum  = 2
        nsg_enabled  = false
        nat_enabled  = false
      }
      bastion_subnet = {
        name         = "bastion"
        cidr_newbits = 10
        cidr_netnum  = 12
        nsg_enabled  = false
        nat_enabled  = false
      }
    }
  }
}

module "hub_network" {
  source              = "./modules/net/"
  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location
  vnet_config = local.hub_vnet

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

| Name                | Description                                                                 | Type          | Default | Required |
| ------------------- | --------------------------------------------------------------------------- | ------------- | ------- | -------- |
| resource_group_name | (Required) The name of the resource group in which to create the resources. | `string`      | n/a     | yes      |
| location            | (Required) The Azure region where resources will be created.                | `string`      | n/a     | yes      |
| vnet_config         | (Required) A map defining the Virtual Network and its subnets.              | `map(any)`    | n/a     | yes      |
| tags                | (Optional) A mapping of tags to assign to the resource.                     | `map(string)` | `{}`    | no       |

## Outputs

| Name                    | Description                           |
| ----------------------- | ------------------------------------- |
| vnet_id                 | The ID of the Virtual Network.        |
| subnet_id(deprecated)   | The ID of the default Subnet.         |
| subnet_ids              | The IDs of the default Subnets.       |
| subnet_name(deprecated) | The name of the default Subnet.       |
| subnet_names            | The names of the default Subnets.     |
| nsg_id                  | The ID of the Network Security Group. |
