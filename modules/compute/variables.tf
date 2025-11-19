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

variable "username" {
  type        = string
  description = "The admin username for the VM"
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

variable "size" {
  type        = string
  description = "The size of the VM (e.g., Standard_DS1_v2)"
  default     = "Standard_DS1_v2"
}

variable "environment" {
  type        = string
  description = "The environment for the resources (e.g., dev, prod)"
  validation {
    condition     = contains(["dev", "test", "prod", "core"], var.environment)
    error_message = "The environment must be one of: dev, test, prod, core."
  }
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the network interface will be created"
}

variable "ssh_public_key" {
  description = "Path to the SSH public key for VM access"
  type        = string
}

variable "appgw_backend_pool_id" {
  type        = string
  description = "The ID of the Application Gateway backend pool"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
