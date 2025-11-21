variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "jih"
  validation {
    condition     = length(var.prefix) <= 6
    error_message = "Prefix must be 6 characters or less to fit storage account naming (24 char limit)."
  }
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

variable "username" {
  description = "The admin username for the VM"
  type        = string
  default     = "adminuser"
}

variable "admin_email" {
  description = "Email address of the administrator for notifications"
  type        = string
}

variable "size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "project_name" {
  type = string

  validation {
    condition     = length(var.project_name) <= 8
    error_message = "Project name must be 8 characters or less to fit storage account naming."
  }
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "purge_protection_enabled" {
  description = "Enable purge protection for the Key Vault"
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain deleted Key Vaults"
  type        = number
  default     = 7

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention must be between 7 and 90 days."
  }
}

variable "env_version" {
  description = "The version of the environment following semantic versioning (e.g., v1.0.0)"
  type        = string
  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.env_version))
    error_message = "The environment version must follow semantic versioning (e.g., v1.0.0)."
  }
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
