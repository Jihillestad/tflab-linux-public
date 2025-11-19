variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resources"
}

variable "location" {
  type    = string
  default = "norwayeast"
  validation {
    condition     = contains(["norwayeast", "norwaywest", "westeurope", "northeurope"], var.location)
    error_message = "The location must be one of: norwayeast, norwaywest, westeurope, northeurope."
  }
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string

  validation {
    condition     = length(var.prefix) <= 10
    error_message = "Prefix must be 10 characters or less to fit storage account naming (24 char limit)."
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
  validation {
    condition     = contains(["dev", "test", "prod", "core"], var.environment)
    error_message = "The environment must be one of: dev, test, prod, core."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
