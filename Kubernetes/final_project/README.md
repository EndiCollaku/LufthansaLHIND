# 🧾 Inventory Management System

A production-ready Inventory Management System deployed with Kubernetes using Helm. It includes:

- **Flask REST API** for managing products
- **HTML/JS frontend** for user interaction
- **PostgreSQL** for data persistence
- **pgAdmin** for DB administration
- **CronJob** for nightly cleanup of discontinued products
- **Security best practices** with RBAC, NetworkPolicies, Secrets, and ConfigMaps

---

## 🧱 Architecture
+-------------------+ +--------------------+
| Frontend | <---> | Flask API |
| HTML/JS (Docker) | | Python |
+-------------------+ +--------------------+
|
v
+--------------------+
| PostgreSQL DB |
| StatefulSet + PVCs |
+--------------------+
|
+--------------------+
| CronJob |
| Inventory Cleanup |
+--------------------+
## 🚀 Deployment

Ensure you have Helm installed and access to a Kubernetes cluster.

### 1. Clone the Repository

```bash
git clone https://lhind-devops-bootcamp@dev.azure.com/lhind-devops-bootcamp/lhind-devboot-04-25/_git/endi-collaku
cd inventory-app

2. Install Helm Dependencies 
helm dependency update

3. Deploy the Application
helm install inventory-app .

🌐 Accessing the Application

🔹 Frontend UI
kubectl port-forward svc/inventory-app-frontend 8080:80

🔹 Backend API
kubectl port-forward svc/inventory-app-backend 5000:5000

🔹 pgAdmin
kubectl port-forward svc/inventory-app-pgadmin 8081:80

Management & Monitoring
1. Check Pod Status
kubectl get pods -l app.kubernetes.io/instance=inventory-app

2. View Logs
kubectl logs -l app.kubernetes.io/instance=inventory-app -f

Testing the Cleanup CronJob
1. Manual Trigger
kubectl create job --from=cronjob/inventory-app-cleanup manual-cleanup-test

2. Monitor CronJob
kubectl get cronjobs
kubectl get jobs
kubectl logs job/manual-cleanup-test

🔐 Security Highlights:

All containers run as non-root
Root filesystems set to read-only
All Linux capabilities dropped
NetworkPolicies:
Only backend & pgAdmin can access PostgreSQL
All other access is restricted

RBAC:

Backend can access Secrets and ConfigMaps
CronJob has scoped permissions to call backend APIs
Follows the least-privilege model

Helm Chart Structure:

inventory-app/
├── Chart.yaml
├── values.yaml
├── .helmignore
├── templates/
│   ├── frontend/
│   ├── backend/
│   ├── postgres/
│   ├── pgadmin/
│   ├── cronjob.yaml
│   ├── networkpolicy.yaml
│   ├── serviceaccounts.yaml
│   ├── readonly-role.yaml
│   ├── readonly-rolebinding.yaml
│   ├── NOTES.txt
│   └── _helpers.tpl

