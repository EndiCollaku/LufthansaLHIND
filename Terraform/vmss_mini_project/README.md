Azure Infrastructure with Terraform

This Terraform project deploys a complete Azure infrastructure including networking, security, and compute resources using a modular approach.
It creates VMSS resources with 2 instances, 1 vnet, 1 subnet and key vaul to store secrets.

Architecture Overview

![Image Alt](https://dev.azure.com/lhind-devops-bootcamp/58545005-5116-4aff-9eab-6e1a3086f68f/_apis/git/repositories/3b13bd79-7a8c-44ab-9f3c-8bee466932b6/items?path=/Terraform/vmss_mini_project/images/resource_visualizer.png&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=main&resolveLfs=true&%24format=octetStream&api-version=5.0)

The project creates:

Virtual Network with subnets
Azure Key Vault for secrets management
Virtual Machine Scale Set (VMSS)
Secure password generation and storage
Random resource naming for uniqueness

Project Structure:

project-root/
├── main.tf # Root configuration
├── outputs.tf # Root outputs
└── modules/
├── random/
│ ├── main.tf # Random ID generation
│ └── outputs.tf # Random module outputs
├── networking/
│ ├── main.tf # VNet & Subnet resources
│ ├── variables.tf # Networking input variables
│ └── outputs.tf # Networking outputs
├── key_vault/
│ ├── main.tf # Key Vault resource
│ ├── variables.tf # Key Vault input variables
│ └── outputs.tf # Key Vault outputs
├── password/
│ ├── main.tf # Password generation & secret
│ ├── variables.tf # Password input variables
│ └── outputs.tf # Password outputs
└── vmss/
├── main.tf # VMSS resource
├── variables.tf # VMSS input variables
└── outputs.tf # VMSS outputs

Prerequisites

Terraform >= 1.0
Azure CLI installed and configured
Azure subscription with appropriate permissions
Service Principal or Managed Identity with Contributor role

Authentication:

az login
az account set --subscription "your-subscription-id"

Usage

Clone the repository
bashgit clone https://lhind-devops-bootcamp@dev.azure.com/lhind-devops-bootcamp/lhind-devboot-04-25/_git/endi-collaku 
cd project-root

Initialize Terraform
terraform init

Plan the deployment
terraform plan

Apply the configuration
terraform apply

Clean up resources
terraform destroy

Module Details
Random Module

Generates unique identifiers for resource naming
Ensures resource names don't conflict across deployments

Networking Module

Creates Azure Virtual Network (VNet)
Configures subnets for different tiers
Sets up network security groups and rules

Inputs:

Resource group information
CIDR blocks for VNet and subnets
Location and naming conventions

Key Vault Module

Deploys Azure Key Vault for secrets management
Configures access policies
Enables soft delete and purge protection

Inputs:

Resource group details
Access policy configurations
SKU and feature settings

Password Module

Generates secure random passwords
Stores passwords as secrets in Key Vault
Manages password rotation policies

Inputs:

Key Vault reference
Password complexity requirements
Secret naming conventions

VMSS Module

Creates Virtual Machine Scale Set
Configures auto-scaling policies
Sets up load balancer integration
Manages VM extensions and configuration

Inputs:

Network configuration
VM specifications (size, image, etc.)
Scaling parameters
Authentication credentials