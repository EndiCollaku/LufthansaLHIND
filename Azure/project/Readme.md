1. Networking

In the existing Azure Resource Group rg-endi-collaku, I begin by creating two separate Virtual Networks (VNets) to establish a segmented and organized network architecture. The first VNet, named vnet-frontend, is configured with the address space 10.1.0.0/16, and the second, vnet-backend, uses 10.2.0.0/16. Within each VNet, a subnet is created: frontend-subnet under vnet-frontend and backend-subnet under vnet-backend. To ensure that the frontend application can communicate with the backend database service, we peer the two VNets. This VNet peering enables seamless IP-based communication across both networks without routing through the public internet.

2. Frontend VMSS and Public Load Balancer
Next, I deploy a Virtual Machine Scale Set (VMSS) in the vnet-frontend to serve as the frontend tier of our application. The VMSS uses an Ubuntu image, and the instances are configured using either a custom script extension or manual SSH access. Each instance is set up to install Python, pip, and virtualenv. The application is then deployed and run within a virtual environment. To serve HTTP traffic, NGINX is installed and configured as a reverse proxy listening on port 80, forwarding requests to the Python application.

To make the frontend application accessible from the internet, a Public Load Balancer is deployed and associated with the frontend VMSS. This load balancer distributes incoming traffic across the VMSS instances based on health checks. A health probe is configured on TCP port 80 to monitor instance availability. A load balancing rule is created to forward requests on port 80 from the public frontend IP to the NGINX service on each instance.


3. Backend VMSS and Internal Load Balancer
The backend of the application is deployed as a second VMSS within the vnet-backend. Like the frontend, this scale set is based on Ubuntu. The primary task of these backend instances is to host a PostgreSQL database. The VMSS is configured to install and set up PostgreSQL using a predefined schema provided for the application.

To maintain security and avoid public exposure, an Internal Load Balancer (ILB) is used for the backend. This ILB is assigned a private frontend IP and does not have a public IP address. A health probe is configured on TCP port 5432, which is the default PostgreSQL port, to monitor the health of the database instances. A load balancing rule ensures traffic on port 5432 is evenly distributed across the backend VMSS instances. Importantly, access to the database through this load balancer is restricted to requests originating from the frontend-subnet.


4. Security Configuration Using NSGs
To enforce security best practices, Network Security Groups (NSGs) are configured for both frontend and backend subnets. For the frontend NSG, rules are created to allow inbound traffic on port 80 from the internet, enabling public access to the application. Additionally, port 22 is optionally opened to allow SSH access for administrative purposes.

On the backend side, stricter access controls are applied. The backend NSG permits inbound traffic only on port 5432 and exclusively from the IP range associated with the frontend-subnet. This ensures that only the application layer can communicate with the database. All other inbound traffic to the backend is explicitly denied, reducing the attack surface and enhancing the security posture of the infrastructure.

CHALLANGES
Networking & VNet Peering
Setting up VNet peering between vnet-frontend and vnet-backend should be straightforward, but misconfigurations such as overlapping IP ranges or incorrect peering settings can prevent communication. Additionally, if subnets are not properly defined, VMs may fail to connect across networks.

Frontend VMSS & Load Balancer Issues
The custom script for setting up Python, NGINX, and the app could fail due to missing dependencies or permission issues. If NGINX isn't configured correctly as a reverse proxy, the app wont be accessible. The public load balancer may also face problems if health probes fail (e.g., the app isn't running on port 80) or if public IP assignment is blocked by quota limits.

Backend VMSS & PostgreSQL Configuration
PostgreSQL installation might fail if dependencies are missing or if the schema isn't applied properly. The internal load balancer must have the correct private IP and health probe for port 5432, or database connections will fail. Security is another concern PostgreSQL must allow connections only from the frontend subnet, which requires proper pg_hba.conf and NSG rules.

Security & NSG Misconfigurations
NSGs must be carefully configured to allow frontend traffic (port 80 from the internet, port 5432 from the frontend subnet) while blocking everything else. A common mistake is incorrect rule priority, where a "Deny All" rule blocks legitimate traffic before the allow rules are evaluated.

Testing & Debugging
When testing, the app might not be reachable via the load balancers public IP if the backend isn't properly connected. Database connection errors could occur if the app's configuration points to the wrong internal LB IP or has incorrect credentials. SSH access might also fail if NSGs block port 22 or if VMSS instances lack proper access settings.