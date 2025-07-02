variable "vmss_name" {
  description = "Name of the VMSS"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region location"
  type        = string
}

variable "sku" {
  description = "SKU for the VMSS instances"
  type        = string
  default     = "Standard_B1s"
}

variable "instances" {
  description = "Number of instances in the VMSS"
  type        = number
  default     = 2
}

variable "subnet_id" {
  description = "ID of the subnet for VMSS"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VMSS instances"
  type        = string
  default     = "endi"
}

variable "admin_password" {
  description = "Admin password for VMSS instances"
  type        = string
  sensitive   = true
}
