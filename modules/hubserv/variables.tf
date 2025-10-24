variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resources"
}

variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the hub VNet (used for resource naming)"
}

variable "bastion_subnet_id" {
  type        = string
  description = "The ID of the subnet for Azure Bastion (must be named AzureBastionSubnet)"
}

variable "appgw_subnet_id" {
  type        = string
  description = "The ID of the subnet for Application Gateway"
}

variable "nat_gateway_subnets" {
  type        = map(string)
  description = "Map of subnet keys to subnet IDs for NAT Gateway association"
  default     = {}
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
