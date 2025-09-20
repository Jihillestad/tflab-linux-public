variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "jih"
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

variable "size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "project_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "env_version" {
  description = "The version of the environment following semantic versioning (e.g., v1.0.0)"
  type        = string
  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.env_version))
    error_message = "The environment version must follow semantic versioning (e.g., v1.0.0)."
  }
}
