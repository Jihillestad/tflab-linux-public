variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "jih"
}

variable "location" {
  type    = string
  default = "norwayeast"
}

variable "username" {
  type    = string
  default = "adminuser"
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
  type = string
}
