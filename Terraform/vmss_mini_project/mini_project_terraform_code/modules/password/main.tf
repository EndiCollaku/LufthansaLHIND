terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.31"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6"
    }
  }
}

resource "random_password" "admin_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "vmss-admin-password"
  value        = random_password.admin_password.result
  key_vault_id = var.key_vault_id

  depends_on = [var.key_vault_id]
}