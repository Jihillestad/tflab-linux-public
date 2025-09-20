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

variable "username" {
  type        = string
  description = "The admin username for the VM"
}

variable "size" {
  type        = string
  description = "The size of the VM (e.g., Standard_DS1_v2)"
  default     = "Standard_DS1_v2"
}

variable "environment" {
  type        = string
  description = "The environment for the resources (e.g., dev, prod)"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the network interface will be created"
}

variable "ssh_public_key" {
  description = "Path to the SSH public key for VM access"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
