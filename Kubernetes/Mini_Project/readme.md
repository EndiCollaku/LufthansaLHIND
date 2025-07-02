A microservice-based Kubernetes project deploying a web app frontend, a user service backend, a metrics logger, and a scheduled cleanup job—all running in the mini-project namespace. This setup demonstrates internal communication using ClusterIP, persistent storage sharing via PVC, and efficient resource management.

mini-project/
├── k8s_miniproject/
│   ├── web_app.yaml
│   ├── namespace.yaml
│   ├── metrics.yaml
│   ├── logs-pvc.yaml
│   ├── logs-pv.yaml
│   └── cronjob.yaml
    └── backend.yaml
├── README.md


Project Components
1. Web App (Frontend)
Deployment with 1 replica

Sends HTTP requests to the User Service

Container image: endi315/web-app:latest

Service Type: ClusterIP (web-app)

2.User Service (Backend)
Deployment with 1 replica

Returns static JSON data (e.g., user profile)

Container image: endi315/user-service

Service Type: ClusterIP (user-service)

3. Metrics Logger
StatefulSet with 1 replica

Writes a new log file to /logs every 5 minutes

Uses busybox and shell loop to simulate logging

Mounts a PersistentVolumeClaim: logs-pvc

4. Log Cleanup
CronJob scheduled daily at 12:00 PM

Deletes log files older than 1 day from /logs

Uses busybox and find command

Shares the same PVC as Metrics pod

Resource Requests & Limits
All workloads include resource constraints:

Component	CPU Requests	CPU Limits	Mem Requests	Mem Limits
Web App	100m	250m	128Mi	256Mi
User Service	100m	250m	128Mi	256Mi
Metrics Logger	50m	100m	64Mi	128Mi
Log Cleanup	50m	100m	64Mi	128Mi

Storage Configuration
PersistentVolume (logs-pv)
path: "/mnt/data/logs"
capacity: 1Gi
accessModes: ReadWriteOnce
PersistentVolumeClaim (logs-pvc)
Requested: 1Gi storage

Used by: metrics and log-cleanup

Deployment Instructions

1. Create Namespace
kubectl create namespace mini-project

2. Apply Persistent Volume and PVC
kubectl apply -f logs-pv.yaml
kubectl apply -f logs-pvc.yaml -n mini-project

3. Deploy Backend and Frontend
kubectl apply -f user-service.yaml -n mini-project
kubectl apply -f web-app.yaml -n mini-project

4. Deploy Metrics Logger
kubectl apply -f metrics.yaml -n mini-project

5. Deploy CronJob for Cleanup
kubectl apply -f cleanup.yaml -n mini-project



