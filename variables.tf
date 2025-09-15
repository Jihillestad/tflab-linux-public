variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "jih"
}
variable "location" {
  type    = string
  default = "norwayeast"
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
