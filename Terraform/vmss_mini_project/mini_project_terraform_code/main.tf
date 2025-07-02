terraform {
  backend "azurerm" {
    subscription_id = "0decc601-03a9-429a-b413-f056fecc9195"
    resource_group_name = "bootcamp-general-rg"
    storage_account_name = "devopsbootcampstate"
    container_name = "endi-tfstate"
    key = "endi_terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.31"  
    }
  }
}


provider "azurerm" {
  subscription_id = "0decc601-03a9-429a-b413-f056fecc9195"
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Data source for existing resource group
data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "existing" {
  name = "rg-endi-collaku"
}

# Random ID for unique naming
module "random" {
  source = "./modules/random"
}

# Networking module
module "networking" {
  source = "./modules/networking"
  
  resource_group_name = data.azurerm_resource_group.existing.name
  location           = data.azurerm_resource_group.existing.location
}

# Key Vault module
module "key_vault" {
  source = "./modules/key_vault"
  
  resource_group_name = data.azurerm_resource_group.existing.name
  location           = data.azurerm_resource_group.existing.location
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  random_suffix      = module.random.suffix
}

# Password module
module "password" {
  source = "./modules/password"
  
  key_vault_id = module.key_vault.key_vault_id
}

# VMSS instances configuration
locals {
  vmss_instances = {
    "vmss-1" = {
      name     = "vmss-linux-1"
      instances = 2
      sku      = "Standard_B1s"
    }
    "vmss-2" = {
      name     = "vmss-linux-2"
      instances = 2
      sku      = "Standard_B1s"
    }
  }
}

# VMSS module with for_each
module "linux_vmss" {
  source = "./modules/vmss"
  
  for_each = local.vmss_instances

  vmss_name           = each.value.name
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  instances           = each.value.instances
  sku                 = each.value.sku
  subnet_id           = module.networking.subnet_id
  admin_username      = "endi"
  admin_password      = module.password.admin_password
}