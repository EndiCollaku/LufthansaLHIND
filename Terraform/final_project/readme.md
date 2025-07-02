# Terraform Production Environment Deployment

## Overview
This Terraform project provisions a scalable production environment consisting of:
- Two Virtual Machine Scale Sets (VMSS): Frontend & Backend
- Two Load Balancers: Public (Frontend) & Internal (Backend)
- Segregated Virtual Networks (VNets) for Frontend and Backend
- A Python application behind a public load balancer
- A secured PostgreSQL database served from the backend VMSS

## Architecture
The system is designed to enhance security and scalability:
- **Frontend VMSS** serves the Python application and is exposed via a Public Load Balancer.
- **Backend VMSS** securely hosts PostgreSQL and is only accessible via the Internal Load Balancer.
- Network segmentation ensures controlled traffic flow between services.
- **Azure Key Vault** manages secrets securely.

## Prerequisites
Ensure you have:
- Terraform installed (`terraform >= 3.x`)
- Azure CLI configured (`az login`)
- Required Azure resource group and permissions

## Deployment Steps
1. Clone the repository:
   ```sh
   git clone https://lhind-devops-bootcamp@dev.azure.com/lhind-devops-bootcamp/lhind-devboot-04-25/_git/endi-collaku
   cd final_project

Initialize Terraform:

terraform init
Apply Terraform configuration:

terraform apply -auto-approve
Validate deployment:

Fetch frontend Load Balancer IP (az network lb show)

Confirm Python app is running (curl <frontend-lb-ip>)


Security best practices implemented:

NSGs: Restricts access based on required ports.

Frontend: Allows HTTP (port 80) and optional SSH (port 22).

Backend: Limits database traffic to frontend subnet only.

Key Vault Integration: Stores credentials securely, preventing hard-coded secrets.

Database Protection: PostgreSQL database is only accessible via internal load balancing, reducing exposure.


Testing
Access the Python application via the frontend Load Balancer.

Validate database interactions by querying PostgreSQL from a frontend VM.

SSH into VMSS instances for troubleshooting (if needed).

Challenges & Improvements

Auto-Scaling Enhancement: Implement dynamic VMSS scaling based on workload metrics like CPU usage or memory consumption.
Infrastructure-as-Code Best Practices: Refactor Terraform configurations using modules to improve reusability and organization.
Key Vault implemtation.
