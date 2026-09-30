Absolutely. Here is the **complete `README.md` in one copy-and-paste Markdown block**.

````markdown
# E-Commerce Resilience & High Availability with Terraform

## 📌 Project Overview

This project demonstrates how to build a resilient, highly available, and scalable AWS infrastructure for an e-commerce application using Terraform.

The project is based on a scenario where an e-commerce application experiences a major increase in traffic during events such as Black Friday.

The original environment has a small number of EC2 instances behind a load balancer, with the infrastructure concentrated in a single Availability Zone. A sudden increase in traffic could overwhelm the servers and cause significant downtime.

The goal of this project was to redesign the infrastructure so that it can:

- Handle sudden traffic increases
- Distribute traffic across multiple EC2 instances
- Automatically replace unhealthy instances
- Scale EC2 capacity based on workload
- Reduce single points of failure
- Keep the database highly available
- Use Infrastructure as Code instead of manually creating resources

---

## 🎯 Project Objective

The main objective was to design and deploy an AWS architecture that provides:

- High availability
- Automatic scaling
- Fault tolerance
- Load balancing
- Database resilience
- Infrastructure automation

The architecture was designed to handle changing workloads while avoiding unnecessary infrastructure capacity during periods of lower traffic.

---

## 🏗️ Architecture

```text
                         INTERNET
                            │
                            ▼
                    Application Load
                       Balancer
                            │
                     Target Group
                       /       \
                      ▼         ▼
                 EC2 - AZ A  EC2 - AZ B
                    │           │
                    └─────┬─────┘
                          │
                          ▼
                     RDS MySQL
                      Multi-AZ


          Launch Template
                 │
                 ▼
        Auto Scaling Group
                 │
                 ▼
          EC2 Capacity


          CloudWatch
               │
               ▼
       Monitoring / Scaling
````

---

# ☁️ AWS Services Used

## Amazon VPC

Created an isolated virtual network for the application infrastructure.

The VPC uses:

```text
10.20.0.0/16
```

It contains separate public and private subnets across multiple Availability Zones.

---

## Availability Zones

The infrastructure is distributed across two Availability Zones to reduce dependence on a single location.

This improves resilience because the application is not dependent on a single Availability Zone.

---

## Internet Gateway

The Internet Gateway provides a path between the VPC and the public internet.

It allows resources in the public subnets to communicate with the internet when the appropriate routing and public addressing are configured.

---

## Route Tables

Route tables control where network traffic should be sent.

The public route table contains a route similar to:

```text
0.0.0.0/0 → Internet Gateway
```

This allows traffic destined for the internet to leave through the Internet Gateway.

---

# 🔐 Security

## Security Groups

Three main security groups were created.

### ALB Security Group

Allows:

```text
HTTP  → Port 80
HTTPS → Port 443
```

from the internet.

### EC2 Security Group

Allows:

```text
HTTP → Port 80
```

only from the Application Load Balancer security group.

The EC2 instances are therefore not directly exposed to the internet.

### RDS Security Group

Allows:

```text
MySQL → Port 3306
```

only from the EC2 security group.

This creates a controlled communication path:

```text
Internet
   │
   ▼
  ALB
   │
   ▼
  EC2
   │
   ▼
  RDS
```

---

# ⚖️ Application Load Balancer

The Application Load Balancer acts as the public entry point for the application.

Instead of users connecting directly to an EC2 instance:

```text
User → EC2
```

traffic follows:

```text
User
 ↓
ALB
 ↓
Target Group
 ↓
EC2
```

The ALB distributes incoming application traffic across healthy EC2 instances.

This prevents a single EC2 instance from becoming the only destination for incoming traffic.

---

# 🎯 Target Group

The Target Group contains the EC2 instances behind the Application Load Balancer.

The Target Group performs health checks against the application.

The health check uses:

```text
Protocol: HTTP
Port: 80
Path: /
Expected response: 200
```

If an instance becomes unhealthy, the load balancer can stop sending traffic to that instance.

---

# 🖥️ EC2

EC2 provides the virtual servers that run the application environment.

The instances use Ubuntu and Apache.

The application flow is:

```text
ALB
 ↓
EC2
 ↓
Apache
 ↓
Website
```

Apache runs **inside the EC2 instance**.

EC2 is the virtual computer, while Apache is the web server software running on that computer.

---

# 🌐 Apache

Apache is the web server software running inside the EC2 instances.

It listens for HTTP requests and serves the website content.

The relationship is:

```text
EC2
└── Ubuntu
    └── Apache
        └── Website
```

---

# 🚀 Launch Template

The Launch Template acts as the blueprint for the EC2 instances.

It defines configuration such as:

* Ubuntu AMI
* Instance type
* Security group
* User data
* Instance configuration
* Tags

This allows the Auto Scaling Group to consistently launch new EC2 instances using the same configuration.

---

# 📈 Auto Scaling Group

The Auto Scaling Group manages the EC2 capacity for the application.

Configuration:

```text
Minimum: 2
Desired: 2
Maximum: 4
```

The Auto Scaling Group can:

* Maintain the desired number of instances
* Replace unhealthy instances
* Add capacity when demand increases
* Remove excess capacity when demand decreases

The application therefore does not depend on a single EC2 instance.

---

# 📊 Auto Scaling Policy

A target-tracking scaling policy was configured using average EC2 CPU utilization.

Target:

```text
60% CPU
```

The Auto Scaling Group can adjust EC2 capacity as workload changes.

Conceptually:

```text
Higher workload
      ↓
Higher CPU
      ↓
ASG adds capacity
```

And:

```text
Lower workload
      ↓
Lower CPU
      ↓
ASG can reduce capacity
```

---

# 🗄️ Amazon RDS

Amazon RDS is used as the application's relational database.

The project uses:

```text
MySQL
```

The database is deployed in private subnets and is not publicly accessible.

The EC2 instances communicate with RDS over:

```text
Port 3306
```

The application architecture is therefore:

```text
EC2
 ↓
RDS MySQL
```

---

# 🔄 RDS Multi-AZ

RDS is configured for Multi-AZ deployment.

The purpose is to improve database availability and provide failover capability if the primary database instance becomes unavailable.

Conceptually:

```text
Availability Zone A
┌─────────────────┐
│ Primary RDS     │
└────────┬────────┘
         │
         │ Replication
         ▼
Availability Zone B
┌─────────────────┐
│ Standby RDS     │
└─────────────────┘
```

Multi-AZ is primarily an availability and failover feature, not a way to make normal database queries twice as fast.

---

# 📦 RDS Subnet Group

An RDS subnet group defines the subnets and Availability Zones that RDS can use for the database infrastructure.

The project uses private subnets across multiple Availability Zones.

---

# 📡 CloudWatch

CloudWatch is used for monitoring and observability.

The project monitors EC2 CPU utilization.

A CloudWatch alarm was configured with a threshold of:

```text
80% CPU
```

CloudWatch helps provide visibility into infrastructure performance.

The scaling policy and CloudWatch metrics work together to support automatic scaling.

---

# 🔄 Monitoring vs Scaling

CloudWatch and Auto Scaling have different responsibilities.

### CloudWatch

Answers:

> "What's happening with my infrastructure?"

### Auto Scaling Group

Answers:

> "How many EC2 instances should I have?"

The relationship is:

```text
CloudWatch
    │
    ▼
Metrics
    │
    ▼
Auto Scaling Policy
    │
    ▼
Auto Scaling Group
    │
    ▼
EC2 Capacity
```

---

# 🧱 Infrastructure as Code

The infrastructure is provisioned using Terraform.

Instead of manually creating each AWS resource through the AWS Console, the infrastructure is defined as code.

This makes the infrastructure:

* Repeatable
* Version controlled
* Easier to modify
* Easier to recreate
* Easier to review

---

# 🛠️ Terraform

Terraform is an Infrastructure as Code (IaC) tool.

It allows infrastructure to be defined using configuration files.

Instead of manually creating:

```text
VPC
Subnets
Route Tables
Security Groups
EC2
ALB
RDS
Auto Scaling
CloudWatch
```

the resources are defined in Terraform.

---

# 📁 Project Structure

```text
ecommerce-resilience-terraform/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── .gitignore
└── README.md
```

### main.tf

Contains the AWS infrastructure resources and architecture.

### variables.tf

Contains configurable project variables such as:

* AWS region
* VPC CIDR
* Subnet CIDRs
* EC2 instance type
* Auto Scaling capacity
* RDS configuration

### outputs.tf

Displays important information after deployment, such as:

* VPC ID
* ALB DNS name
* Auto Scaling Group name
* RDS endpoint
* RDS port
* Availability Zones

---

# 🔑 Terraform Variables

The project uses variables to make the infrastructure easier to configure.

Examples include:

```text
AWS Region
VPC CIDR
Public Subnet CIDRs
Private Subnet CIDRs
EC2 Instance Type
ASG Minimum Size
ASG Desired Capacity
ASG Maximum Size
CPU Target
RDS Database Name
RDS Username
RDS Password
```

Sensitive values such as the RDS password should not be committed to GitHub.

---

# 🧪 Testing

The infrastructure was deployed and tested to verify the main behavior of the architecture.

## 1. Application Access

The ALB DNS name was used to access the application.

Request flow:

```text
Browser
   ↓
ALB
   ↓
Target Group
   ↓
EC2
   ↓
Apache
   ↓
Website
```

---

## 2. Target Health

The Target Group was checked to confirm that the EC2 instances were healthy.

Healthy targets are eligible to receive traffic from the ALB.

---

## 3. EC2 Failure Test

An EC2 instance can be terminated to simulate a server failure.

The expected behavior is:

```text
EC2 instance fails
       ↓
ASG detects reduced capacity
       ↓
ASG launches replacement
       ↓
Launch Template provides configuration
       ↓
New EC2 starts
       ↓
New EC2 registers with Target Group
       ↓
Health check passes
       ↓
ALB can send traffic to it
```

This demonstrates the self-healing behavior of the Auto Scaling Group.

---

## 4. Scaling Configuration

The Auto Scaling Group was configured with:

```text
Minimum: 2
Desired: 2
Maximum: 4
```

The target-tracking policy uses:

```text
CPU Target: 60%
```

This allows the infrastructure to adjust EC2 capacity as workload changes.

---

# 🔄 Request Flow

A normal customer request follows:

```text
Customer
   ↓
Application Load Balancer
   ↓
Target Group
   ↓
EC2 Instance
   ↓
Apache / Application
   ↓
RDS MySQL
   ↓
EC2
   ↓
ALB
   ↓
Customer
```

The Auto Scaling Group is **not directly in the request path**.

Instead, it manages the EC2 instances in the background.

CloudWatch provides metrics that can be used by the scaling policy.

---

# 🧠 Key AWS Concepts Demonstrated

This project demonstrates practical experience with:

* AWS VPC
* CIDR
* Subnets
* Availability Zones
* Internet Gateway
* Route Tables
* Security Groups
* EC2
* Ubuntu
* Apache
* Application Load Balancer
* Target Groups
* Launch Templates
* Auto Scaling Groups
* Target Tracking
* Amazon RDS
* MySQL
* RDS Multi-AZ
* CloudWatch
* Terraform
* Infrastructure as Code
* High Availability
* Fault Tolerance
* Scalability
* Elasticity
* Load Balancing
* Network Security

---

# 🧩 Architecture Responsibilities

Each component has a specific responsibility.

```text
ALB
→ Distributes incoming traffic

Target Group
→ Tracks backend targets and health

EC2
→ Provides the virtual servers running the application

Apache
→ Serves the website

Launch Template
→ Defines how EC2 instances are created

Auto Scaling Group
→ Manages EC2 capacity and replaces unhealthy instances

CloudWatch
→ Monitors infrastructure and provides metrics

RDS
→ Stores relational application data

RDS Multi-AZ
→ Improves database availability and failover capability

Security Groups
→ Control network access

VPC
→ Provides the application network

Terraform
→ Automates infrastructure provisioning
```

---

# 💡 What I Learned

This project helped me understand that building a resilient application is not simply about adding more servers.

Each component has a specific responsibility and works together as part of the overall architecture.

The most important concepts I practiced were:

* Designing a multi-AZ architecture
* Using an Application Load Balancer
* Configuring EC2 instances behind a Target Group
* Creating reusable EC2 configurations with Launch Templates
* Managing EC2 capacity with Auto Scaling Groups
* Using CloudWatch metrics for monitoring and scaling
* Deploying an RDS MySQL database
* Using RDS Multi-AZ for improved availability
* Designing security groups based on application traffic flow
* Building the entire infrastructure with Terraform
* Testing failure and recovery behavior

The biggest lesson was understanding **how the services work together**, rather than treating each AWS service as an isolated component.

---

# 🎥 Project Walkthrough
https://www.loom.com/share/46e9298f920e415192fd9bea39f8846b

A video walkthrough of this project is available on Loom.

**Loom:**
[Add your Loom link here]

---

# 📚 Key Takeaway

The architecture is designed around three major goals:

```text
HIGH AVAILABILITY
        +
AUTOMATIC SCALING
        +
FAULT TOLERANCE
```

The final request flow is:

```text
Internet
   ↓
ALB
   ↓
Target Group
   ↓
EC2 Instances
   ↓
RDS MySQL
```

While the supporting infrastructure works in the background:

```text
Launch Template
       ↓
Auto Scaling Group
       ↓
EC2 Capacity

CloudWatch
       ↓
Metrics
       ↓
Scaling Policy
       ↓
Auto Scaling Group
```

---

# 👨‍💻 Author

**Peter Ozuo**

Cloud / DevOps Engineer in Training

GitHub:
[https://github.com/peterozuo](https://github.com/peterozuo)

````

