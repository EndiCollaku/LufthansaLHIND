The OSI Model (Open Systems Interconnection Model) is a conceptual framework used to understand and standardize how different networking systems communicate with each other. It divides network communication into seven distinct layers, each with specific functions.

This model helps developers and network engineers troubleshoot, design, and understand networking systems more effectively.

| Layer | Name             | Function                                                             |
| ----- | ---------------- | -------------------------------------------------------------------- |
| 7     | **Application**  | Interfaces with end-user applications (e.g., web browsers, email).   |
| 6     | **Presentation** | Formats and encrypts data; handles character encoding (e.g., UTF-8). |
| 5     | **Session**      | Manages sessions and controls dialogues between computers.           |
| 4     | **Transport**    | Ensures reliable data transfer (e.g., TCP/UDP).                      |
| 3     | **Network**      | Handles addressing and routing of data (e.g., IP addresses).         |
| 2     | **Data Link**    | Deals with MAC addresses and error detection at the link level.      |
| 1     | **Physical**     | Transmits raw bits over physical media (e.g., cables, switches).     |

Why is the OSI Model Important?
Standardization: Helps different vendors' hardware and software communicate effectively.
Troubleshooting: Helps isolate problems by layer (e.g., is it a physical cable issue or a transport layer issue?).
Design: Provides a blueprint for building new networking protocols and systems.

Example (Sending an Email)

7.Application: You write an email in Outlook (Layer 7).
6.Presentation: The email is encoded in a readable format (Layer 6).
5.Session: A session is established with the email server (Layer 5).
4.Transport: Data is split into segments and sent reliably via TCP (Layer 4).
3.Network: Each segment is given an IP address and routed (Layer 3).
2.Data Link: The data is converted to frames with MAC addresses (Layer 2).
1.Physical: Frames are converted to electrical signals and sent through a cable (Layer 1).

How does subnets communicate with each other within a VLAN?

In Azure, subnets within the same Virtual Network (VNet) can communicate with each other by default because they share the same address space and Azure handles routing between them automatically at Layer 3. This means that devices in different subnets of the same VNet can talk to each other using their IP addresses without needing any additional configuration, which simplifies network management. Azure's internal routing ensures that communication between these subnets is seamless and efficient. 

+-------------------------+
|         VNet             |
|  +-------------------+    |
|  |   Subnet 1        |    |
|  |   10.0.1.0/24     |    |     Subnets within the same VNet automatically communicate via Layer 3 routing without the need for extra configuration.
|  +-------------------+    |
|  +-------------------+    |
|  |   Subnet 2        |    |
|  |   10.0.2.0/24     |    |
|  +-------------------+    |
|      Azure Routes        |
|    (Automatic Layer 3)    |
+-------------------------+
         |   |
         v   v
   Communication allowed

    
However, the flow of traffic between these subnets can be further controlled and secured using Network Security Groups (NSGs). NSGs allow administrators to create specific rules to allow or deny certain types of traffic based on criteria like IP address, port number, and protocol. These rules can be applied either at the subnet level or to individual virtual machines (VMs), providing fine-grained control over network traffic. 
+-------------------------+
|         VNet              |
|  +-------------------+    |
|  |   Subnet 1        |    |
|  |   10.0.1.0/24     |    |
|  |   [NSG: Allow HTTP]|   |
|  +-------------------+    |     NSGs are applied to individual subnets, controlling which traffic is allowed between them. For example, one subnet may allow HTTP traffic,   
                                  while the other might block SSH.
|  +-------------------+    |
|  |   Subnet 2        |    |
|  |   10.0.2.0/24     |    |
|  |   [NSG: Deny SSH] |    |
|  +-------------------+    |
|     Azure Routes (Layer 3)|
+-------------------------+
         |   |
         v   v
   Communication allowed or denied



If the subnets are located in different VNets, they won’t be able to communicate directly unless VNet Peering is configured. VNet Peering enables VNets to share routing tables, allowing devices in different VNets to communicate with each other as if they were part of the same network. This makes it easier to extend the network across multiple VNets while still maintaining efficient communication between them.

+-------------------------+        +-------------------------+
|         VNet 1           |        |         VNet 2           |
|  +-------------------+    |        |  +-------------------+    |
|  |   Subnet 1        |    |        |  |   Subnet 2        |    |   When subnets are in different VNets, you must use VNet Peering, which allows routing and communication 
                                                                     between VNets, as long as routing tables are shared.
|  |   10.0.1.0/24     |    |        |  |   10.1.1.0/24     |    |
|  +-------------------+    |        |  +-------------------+    |
|   VNet Peering (Layer 3) |        |  VNet Peering (Layer 3) |
+-------------------------+        +-------------------------+
         |   |                            |   |
         v   v                            v   v
    Communication allowed



