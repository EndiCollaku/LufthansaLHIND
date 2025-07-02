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

variable "postgres_password" {
  description = "PostgreSQL database password"
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

variable "frontend_subnet_cidr" {
  description = "CIDR block of the frontend subnet for security rules"
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

variable "internal_lb_private_ip" {
  description = "Static private IP for the internal load balancer"
  type        = string
}

variable "postgres_db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "appdb"
}

variable "postgres_user" {
  description = "PostgreSQL database user"
  type        = string
  default     = "dbuser"
}
