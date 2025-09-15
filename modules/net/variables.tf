variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resources"
}

variable "location" {
  type    = string
  default = "norwayeast"
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
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the Virtual Network"
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
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
