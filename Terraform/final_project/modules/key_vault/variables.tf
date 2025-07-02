variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = null
}

variable "object_id" {
  description = "Azure object ID for access policy"
  type        = string
  default     = null
}

variable "secret_name" {
  description = "Name of the secret to store"
  type        = string
  default     = "vmss-admin-password"
}