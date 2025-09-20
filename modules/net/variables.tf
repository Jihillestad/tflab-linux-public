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

variable "sa_account_tier" {
  description = "The Tier of the Storage Account (Standard or Premium)"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.sa_account_tier)
    error_message = "The account tier must be either Standard or Premium."
  }
}

variable "sa_account_kind" {
  description = "The Kind of the Storage Account (StorageV2, BlobStorage, FileStorage, BlockBlobStorage)"
  type        = string
  default     = "StorageV2"
  validation {
    condition     = contains(["StorageV2", "BlobStorage", "FileStorage", "BlockBlobStorage"], var.sa_account_kind)
    error_message = "The account kind must be one of: StorageV2, BlobStorage, FileStorage, BlockBlobStorage."
  }
}

variable "sa_account_replication_type" {
  description = "The Replication type of the Storage Account (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.sa_account_replication_type)
    error_message = "The account replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "vnet_flow_log_retention_days" {
  description = "Number of days to retain flow logs"
  type        = number
  default     = 7
}

variable "law_id" {
  description = "The ID of the Log Analytics Workspace to link with Network Watcher Flow Logs"
  type        = string
}

variable "law_workspace_id" {
  description = "The Workspace ID of the Log Analytics Workspace to link with Network Watcher Flow Logs"
  type        = string
}

variable "law_region" {
  description = "The region of the Log Analytics Workspace to link with Network Watcher Flow Logs"
  type        = string
  default     = "norwayeast"
  validation {
    condition     = contains(["norwayeast", "norwaywest", "westeurope", "northeurope"], var.law_region)
    error_message = "The Log Analytics Workspace region must be one of: norwayeast, norwaywest, westeurope, northeurope."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
