# 🚀 Automated Kubernetes Cluster on AWS using Terraform + Ansible + kubeadm

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-kubeadm-326CE5?logo=kubernetes&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?logo=amazon-aws&logoColor=white)

This project automates a **production-like Kubernetes cluster on AWS** from scratch using:

✔ **Terraform** – Infrastructure provisioning (Dev & Prod environments)  
✔ **Ansible** – Automates installation + kubeadm cluster setup  
✔ **kubeadm** – Initializes the master and joins worker nodes  
✔ **Calico CNI** – Installed automatically via Ansible during control plane bootstrap  

---
## ✅ Project Overview

| Component         | Purpose |
|------------------|---------|
| **Terraform**    | Creates VPC, Bastion Host, 1 Master, 2 Workers |
| **Dev & Prod Environments** | Isolated workspaces under `infra/terraform/envs/` |
| **Dynamic Inventory** | Auto-generated `inventory.ini` from Terraform output |
| **Ansible Playbooks** | Installs Docker, containerd, kubeadm, kubelet, CNI |
| **Calico CNI**   | Installed automatically via Ansible in `03-init-control-plane.yaml` |
| **Challenge Faced** | Calico CNI Pods kept crashing due to AWS networking (IPIP/BGP mismatch) |

---

## 🏗️ Architecture Diagram

![Architecture of
kubeadm-aws-platform-engineering](/images/diagram-kubeadm-aws-platform-engineering.png)

```
📁 images/
    |
    └── diagram-kubeadm-aws-platform-engineering.png
```
## 📁 Repository Structure

```
├── infra/
│   └── terraform/
│       ├── envs/
│       │   ├── dev/
│       │   └── prod/
│       └── modules/
├── ansible/
│   ├── inventory/dev/inventory.ini   # Auto-generated
│   └── playbooks/
│       ├── 01-setup-base.yaml
│       ├── 02-install-k8s.yaml
│       ├── 03-init-control-plane.yaml   # Installs Calico CNI here
│       ├── 04-join-workers.yaml
│       ├── 05-verify-cluster.yaml
│       └── 06-fix-network.yaml
```

## 🚀 Deployment Guide
### 1️⃣ Provision AWS Infrastructure (Terraform)

```
cd infra/terraform/envs/dev
terraform init                     # Initialize backend and providers
terraform apply -auto-approve      # Create VPC, Bastion, Master, Worker nodes
```

### 2️⃣ SSH into Bastion Host

```
ssh-add ~/.ssh/kubeadm-aws-key         # Add SSH key to agent
ssh -A ubuntu@<bastion_public_ip>      # Connect to bastion
```
### 3️⃣ Run Ansible – Full Kubernetes Setup

```
ansible-playbook -i inventory/dev/inventory.ini playbooks/01-setup-base.yaml
# Sets hostname, disables swap, updates packages

ansible-playbook -i inventory/dev/inventory.ini playbooks/02-install-k8s.yaml
# Installs containerd, kubelet, kubeadm, kubectl

ansible-playbook -i inventory/dev/inventory.ini playbooks/03-init-control-plane.yaml
# kubeadm init + applies Calico CNI automatically
# Also saves join command → artifacts/kubeadm_join.sh

ansible-playbook -i inventory/dev/inventory.ini playbooks/04-join-workers.yaml
# Uses saved join command to add workers to cluster
```
### 4️⃣ Verify Cluster

```
kubectl get nodes        # Master + Worker nodes should show "Ready"
kubectl get pods -A      # Calico, CoreDNS, kube-system pods running
```

## ⚠ Challenges & Lessons Learned

| Challenge                       | What Happened?                                            |
| ------------------------------- | --------------------------------------------------------- |
| ❗ Calico CNI Pods kept crashing | Due to AWS VPC routing + IP-in-IP tunneling conflict      |
| ❗ Manual kubeconfig handling    | Had to copy `/etc/kubernetes/admin.conf` to user manually |
| ❗ No HA Control Plane           | kubeadm master is a single point of failure               |
| ❗ Requires SSH Debugging        | No CloudWatch or managed logging like EKS                 |


## ✅ Why AWS EKS is Easier for Production

✔ AWS manages control plane, etcd, certificates

✔ VPC CNI works out-of-the-box (no Calico issues)

✔ IAM Roles for Service Accounts, Cluster Autoscaler support

✔ Built-in CloudWatch logging, no SSH into nodes

✔ Let’s focus on CI/CD, security, apps — not cluster plumbing

## 🧹 Cleanup & Destroy Resources 
### ✅ Destroy infrastructure via Terraform:

```
cd infra/terraform/envs/dev
terraform destroy -auto-approve
```
### ✅ Optional manual cleanup:


🔹Delete SSH key pair if unused

🔹Remove ~/.kube/config from bastion/local machine

🔹Release Elastic IPs, delete Route53 records

🔹Delete S3 backend & DynamoDB state lock table (if used)

### 🎯 Next Steps

🔹 Terraform + AWS EKS (Managed Kubernetes)

🔹 Deploy GCP Online Boutique microservices

🔹 GitHub Actions + Vault for CI/CD secrets

🔹 Karpenter autoscaling + SonarQube + Nexus + ECR

## ⭐ Like This Project?

If this helped you, feel free to:

  ⭐ Star the repository

  🛠️ Fork and build on top of it

  🤝 Connect & collaborate
