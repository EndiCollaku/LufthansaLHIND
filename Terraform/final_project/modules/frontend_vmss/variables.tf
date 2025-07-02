variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "admin_password" {
  description = "Admin password for VM instances"
  type        = string
  sensitive   = true
}

variable "vnet_name" {
  description = "Name of the existing virtual network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the existing subnet"
  type        = string
}

variable "vmss_instance_count" {
  description = "Number of instances in the VMSS"
  type        = number
  default     = 2
}

variable "vm_sku" {
  description = "VM SKU for VMSS instances"
  type        = string
  default     = "Standard_B2s"
}

output "ssh_nat_pool_info" {
  value = azurerm_lb_nat_pool.ssh_nat_pool
}
