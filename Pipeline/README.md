# Terraform & Helm CI/CD Pipeline Automation

This project implements an automated CI/CD pipeline to deploy infrastructure using **Terraform** and deploy Kubernetes applications using **Helm charts**. The pipeline is designed for a DevOps Engineer to streamline and standardize deployments using Azure DevOps Pipelines.

---

## Overview

The pipeline consists of **five stages** designed to verify, plan, deploy, and test infrastructure and Kubernetes applications:

1. **Verify Stage**  
   Runs two parallel jobs:  
   - **Terraform Verify:** `terraform init`, `terraform validate`, and format checks  
   - **Helm Verify:** Helm chart linting for quality checks

2. **Terraform Plan Stage**  
   Runs `terraform plan` and saves the execution plan as a build artifact for later use.

3. **Terraform Deploy Stage**  
   Applies the Terraform plan to deploy or update infrastructure. This is a deployment job to leverage Azure DevOps Environments.

4. **Helm Deploy Stage**  
   Installs or upgrades the Helm chart to deploy Kubernetes applications, creating namespaces if they don't exist.

5. **Testing Stage**  
   Validates the Helm deployment by checking Helm release status and Kubernetes pod rollout status.

---

## Pipeline Stage Dependencies

- **Terraform Plan** depends on **Verify**
- **Terraform Deploy** depends on **Terraform Plan**
- **Helm Deploy** depends on **Terraform Plan**
- **Testing** depends on **Helm Deploy**

---

## Parameters

| Parameter                     | Description                                   | Example/Default                                   |
|-------------------------------|-----------------------------------------------|--------------------------------------------------|
| `terraform_service_connection`| Azure DevOps Service Connection for Terraform| `bootcamp_scn`                                   |
| `kubernetes_service_connection`| Azure DevOps Service Connection for Kubernetes| `kubernetes_scn`                                |
| `terraform_working_dir`        | Directory path of Terraform configuration     | `$(System.DefaultWorkingDirectory)/Terraform/final_project` |
| `helm_working_dir`             | Directory path of Helm chart                   | `$(System.DefaultWorkingDirectory)/Kubernetes/final_project/inventory-app/` |
| `students_name`                | Unique identifier for the student/developer   | `endi`                                            |
| `helmReleaseName`              | Helm release name for the deployed application| `inventory`                                       |
| `namespace`                   | Kubernetes namespace for deployment            | `endi-collaku-ns`                                 |

---

## Pipeline Stages Details

### 1. Verify Stage

- Terraform jobs run:
  - `terraform init`
  - `terraform validate`
  - `terraform fmt -check -diff`
- Helm job runs:
  - `helm lint` on the Helm chart directory

### 2. Terraform Plan Stage

- `terraform init` with reconfiguration
- `terraform plan` output saved as a `.tfplan` file
- Publish plan as build artifact for later stages

### 3. Terraform Deploy Stage

- Downloads plan artifact
- Runs `terraform init`
- Runs `terraform apply` using the saved plan
- Uses Azure DevOps deployment job with environment for proper deployment tracking

### 4. Helm Deploy Stage

- Installs latest `kubectl`
- Logs into Kubernetes cluster using service connection
- Creates Kubernetes namespace if it doesn't exist
- Runs `helm upgrade --install` to deploy/update the Helm chart
- Verifies pods status after deployment

### 5. Testing Stage

- Logs into Kubernetes cluster
- Checks Helm release status
- Waits for Kubernetes deployments rollout to complete
- Lists pods with details to verify the application status

---

## Usage

1. Clone the repository containing your Terraform configs and Helm charts.

2. Set up your Azure DevOps service connections for:
   - Terraform (Azure subscription with permissions)
   - Kubernetes (AKS cluster or any Kubernetes cluster)

3. Adjust pipeline parameters (either in pipeline UI or YAML) to match your working directories, release names, namespaces, and service connections.

4. Run the pipeline. The stages will execute sequentially based on the dependencies defined.

---

## Example Pipeline YAML snippet (parameters section)

```yaml
parameters:
  - name: students_name
    type: string
    default: endi

  - name: terraform_service_connection
    type: string
    default: "bootcamp_scn"

  - name: kubernetes_service_connection
    type: string
    default: "kubernetes_scn"

  - name: terraform_working_dir
    type: string
    default: $(System.DefaultWorkingDirectory)/Terraform/final_project
  
  - name: helm_working_dir
    type: string
    default: $(System.DefaultWorkingDirectory)/Kubernetes/final_project/inventory-app/
