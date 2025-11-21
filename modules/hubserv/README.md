# HubServ Module

## Description

Creates resources for secure ingress and egresss to/from a hub virtual network.

## Usage

In this example, we are passing in variables from a hub network module. Some
locals are needed to define the vnet and subnets.

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

module "hub_services" {
  source = "./modules/hubserv/"

  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location
  hub_vnet_name       = local.hub_vnet.name
  prefix              = var.prefix
  project_name        = var.project_name
  environment         = var.environment

  # Subnet references from hub network module
  bastion_subnet_id = module.hub_network.subnet_ids["bastion_subnet"]
  appgw_subnet_id   = module.hub_network.subnet_ids["appgw_subnet"]

  # Subnets that should use NAT Gateway
  nat_gateway_subnets = {
    default = module.hub_network.subnet_ids["default"]
  }

  # Monitoring configuration
  admin_email = var.admin_email

  tags = local.common_tags

  depends_on = [
    azurerm_resource_group_policy_assignment.allowed_locations,
    azurerm_resource_group_policy_assignment.require_environment_tag,
  ]
}

module "hub_network" {
  source              = "./modules/net/"
  resource_group_name = azurerm_resource_group.tflab_linux.name
  location            = azurerm_resource_group.tflab_linux.location
  vnet_config         = local.hub_vnet

  tags = local.common_tags

  depends_on = [
    azurerm_resource_group_policy_assignment.allowed_locations,
    azurerm_resource_group_policy_assignment.require_environment_tag,
  ]
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

| Name                | Description                                                                          | Type          | Default  | Required |
| ------------------- | ------------------------------------------------------------------------------------ | ------------- | -------- | -------- |
| resource_group_name | (Required) The name of the resource group in which to create the resources.          | `string`      | n/a      | yes      |
| location            | (Required) The Azure region where resources will be created.                         | `string`      | n/a      | yes      |
| hub_vnet_name       | (Optional) The name of the Hub Virtual Network.                                      | `string`      | n/a      | yes      |
| prefix              | (Optional) Prefix for resouce names.                                                 | `string`      | n/a      | no       |
| project_name        | (Optional) The name of the project.                                                  | `string`      | `"demo"` | no       |
| environment         | (Optional) Environment name for naming resources.                                    | `string`      | `"dev"`  | no       |
| bastion_subnet_id   | (Optional) The ID of the subnet for Azure Bastion (must be named AzureBastionSubnet) | `string`      | n/a      | yes      |
| appgw_subnet_id     | (Optional) The ID of the subnet for Application Gateway                              | `string`      | n/a      | yes      |
| nat_gateay_subnets  | (Optional) Map of subnet keys to subnet IDs for NAT Gateway association              | `map(string)` | n/a      | no       |
| admin_email         | (Optional) Email address of the administrator for notifications.                     | `string`      | `""`     | no       |
| tags                | (Optional) A mapping of tags to assign to the resource.                              | `map(string)` | `{}`     | no       |

## Outputs

| Name                                | Description                                     |
| ----------------------------------- | ----------------------------------------------- |
| bastion_host_id                     | The ID of the Azure Bastion Host.               |
| bastion_host_name                   | The name of the Azure Bastion Host.             |
| bastion_public_ip                   | The public IP of the Azure Bastion Host.        |
| nat_gateway_id                      | The ID of the NAT Gateway.                      |
| nat_gateway_public_ip               | The public IP of the NAT Gateway.               |
| appgw_id                            | The ID of the Application Gateway.              |
| appgw_name                          | The name of the Application Gateway.            |
| appgw_public_ip                     | The public IP of the Application Gateway.       |
| appgw_backend_pool_id               | The ID of the Application Gateway backend pool. |
| appgw_subnet_id                     | The ID of the Application Gateway subnet.       |
| log_analytics_workspace_id          | The workspace ID of the Log Analytics Workspace |
| log_analytics_workspace_name        | The name of the Log Analytics Workspace         |
| log_analytics_workspace_resource_id | The resource ID of the Log Analytics Workspace  |
| log_analytics_workspace_location    | The location of the Log Analytics Workspace     |
