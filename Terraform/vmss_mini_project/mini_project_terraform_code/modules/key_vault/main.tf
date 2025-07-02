terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"

    }
  }
}

resource "azurerm_key_vault" "main" {
  name                = "kv-vmss-${var.random_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore"
    ]
  }
}