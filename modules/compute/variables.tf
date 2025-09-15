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

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the network interface will be created"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
