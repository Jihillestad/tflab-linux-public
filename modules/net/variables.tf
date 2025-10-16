variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resources"
}

variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
  default     = "norwayeast"
  validation {
    condition     = contains(["norwayeast", "norwaywest", "westeurope", "northeurope"], var.location)
    error_message = "The location must be one of: norwayeast, norwaywest, westeurope, northeurope."
  }
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "project_name" {
  type        = string
  description = "The name of the project"
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

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the Virtual Network"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
