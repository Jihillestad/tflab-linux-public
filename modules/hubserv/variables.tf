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

variable "prefix" {
  description = "Prefix for resource names"
  type        = string

  validation {
    condition     = length(var.prefix) <= 6
    error_message = "Prefix must be 6 characters or less to fit storage account naming (24 char limit)."
  }
}

variable "project_name" {
  type        = string
  description = "The name of the project"

  validation {
    condition     = length(var.project_name) <= 8
    error_message = "Project name must be 8 characters or less to fit storage account naming."
  }
}

variable "environment" {
  type        = string
  description = "The environment for the resources (e.g., dev, prod)"
  default     = "dev"
  validation {
    condition     = contains(["dev", "test", "prod", "core"], var.environment)
    error_message = "The environment must be one of: dev, test, prod, core."
  }
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

variable "admin_email" {
  description = "Email address of the administrator for notifications"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
