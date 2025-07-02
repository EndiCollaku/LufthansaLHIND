# Azure Resource Manager

**Azure Resource Manager** is a lightweight, Python-based framework designed to help developers, DevOps engineers, and cloud architects model, validate, and manage Azure cloud infrastructure using structured code. It provides an object-oriented abstraction of core Azure resources such as:

- Virtual Machines (VMs)
- Storage Accounts
- SQL Databases
- Resource Groups

The goal of this tool is to simplify infrastructure-as-code (IaC) for Azure by allowing users to define resources in Python classes and export them into standard JSON configurations. It can be integrated into CI/CD pipelines, infrastructure validation tools, or used standalone for planning and visualization of cloud environments.

---

### 1. Clone the Repository

```bash
git clone https://github.com/endi_collaku/azure_resource_manager.git
cd azure_resource_manager


#Latest Release
Version: 1.0.0

Release Date: May 2025

#Initial Features

Parse and interpret Azure resource definitions from structured JSON.

Map resource types to Python class models for validation and transformation.

Format resource definitions in a clean, standardized JSON structure.

Support for core Azure services including virtual machines and storage accounts.

#Build and Run
python main.py

#Example JSON Structure
Below is a simple example of a JSON file that defines a virtual machine resource:

json
Copy
Edit
{
  "resources": [
    {
      "type": "virtual_machine",
      "name": "vm-001",
      "location": "eastus"
    }
  ]
}
This structure can be expanded to include more Azure services, resource dependencies, and parameterized configurations.

#Project Structure
azure_resource_manager/
│
├── main.py              # Entry point to run the resource parser and validator
├── models/              # Python classes for different Azure resource types
├── utils/               # Helper functions (e.g., validation, formatting,file handler)
└── data/                # Sample JSON files and logs


```
