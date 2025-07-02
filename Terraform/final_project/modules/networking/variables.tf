variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
  default     = "bootcamp-general-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "West Europe"
}

variable "frontend_vnet_name" {
  description = "Name of the frontend virtual network"
  type        = string
  default     = "endi-vnet-frontend"
}

variable "backend_vnet_name" {
  description = "Name of the backend virtual network"
  type        = string
  default     = "endi-vnet-backend"
}

variable "frontend_address_space" {
  description = "Address space for frontend VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "backend_address_space" {
  description = "Address space for backend VNet"
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

variable "frontend_subnet_name" {
  description = "Name of the frontend subnet"
  type        = string
  default     = "frontend-subnet"
}

variable "backend_subnet_name" {
  description = "Name of the backend subnet"
  type        = string
  default     = "backend-subnet"
}

variable "frontend_subnet_prefix" {
  description = "Address prefix for frontend subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "backend_subnet_prefix" {
  description = "Address prefix for backend subnet"
  type        = string
  default     = "10.2.1.0/24"
}