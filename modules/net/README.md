# Net Module

## Description

Creates an Azure network intended for Lab usage.

## Usage

Pass a map of objecte defining the vnet and subnets.

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

| Name                | Description                                                                 | Type           | Default | Required |
| ------------------- | --------------------------------------------------------------------------- | -------------- | ------- | -------- |
| resource_group_name | (Required) The name of the resource group in which to create the resources. | `string`       | n/a     | yes      |
| location            | (Required) The Azure region where resources will be created.                | `string`       | n/a     | yes      |
| address_space       | (Required) The address space that is used by the virtual network.           | `list(string)` | n/a     | yes      |
| tags                | (Optional) A mapping of tags to assign to the resource.                     | `map(string)`  | `{}`    | no       |

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
