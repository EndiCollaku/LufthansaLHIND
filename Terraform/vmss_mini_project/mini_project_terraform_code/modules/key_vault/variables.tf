variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region location"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "object_id" {
  description = "Azure object ID for access policy"
  type        = string
}

variable "random_suffix" {
  description = "Random suffix for unique naming"
  type        = string
}