# 🚀 AWS Kubernetes Cluster Automation (Terraform + Ansible + kubeadm)

A fully automated, production-like Kubernetes cluster built on AWS using **Terraform**, **Ansible**, and **kubeadm**.

This project provisions infrastructure (VPC, Bastion, Master, Worker Nodes), installs Kubernetes using Ansible automation, and bootstraps the cluster with kubeadm.  
However, the journey didn’t end perfectly — and that’s the best part of the story.

---

## ✅ Project Overview

### **🔹 Technologies Used**
| Tool       | Purpose |
|------------|---------------------------------------------------------------|
| Terraform  | Provision AWS Infrastructure (Dev + Prod Environments)        |
| Ansible    | Automate Kubernetes installation & configuration              |
| kubeadm    | Initialize control plane & join worker nodes                  |
| AWS EC2    | Master, Worker & Bastion Nodes                                |
| S3 + DynamoDB | Remote backend for Terraform state management             |

---

## 🛠 Infrastructure Architecture

### **Terraform (IaC)**
✔ Separate workspaces for Dev & Prod  
✔ Provisions:
- VPC & Subnets (Public + Private)
- Bastion Host (SSH Gateway)
- 1 Master Node, 2 Worker Nodes  
✔ Remote State stored in S3 (state lock via DynamoDB)  
✔ Outputs dynamic inventory for Ansible

```
infra/
└── terraform/
├── envs/      
│   ├── dev/
|   └── prod/
├── modules/
└── backend (S3 + DynamoDB)
```

---

### **Ansible (Cluster Setup Automation)**

✔ Automatically generates `inventory.ini` using Terraform output  
✔ Playbooks executed in sequence:

```
ansible/
└── playbooks/
├── 01-setup-base.yaml # OS hardening & dependencies
├── 02-install-kubernetes.yaml # kubeadm, kubelet, kubectl
├── 03-init-control-plane.yaml # kubeadm init
├── 04-join-workers.yaml # kubeadm join
├── 05-verify-cluster.yaml # Health checks
└── 06-fix-networking.yaml # CNI configuration
```

---

## ⚙️ kubeadm Bootstrap Summary

✔ kubeadm init → API Server, etcd, scheduler & controller running  
✔ kubeconfig copied to Bastion for kubectl access  
✔ Worker nodes auto-joined using `kubeadm join` token  
✔ Cluster reachable via Bastion → `kubectl get nodes`

---

## ⚠️ Real-World Issue Faced

| Problem | Description |
|---------|-------------|
| ❌ Calico CNI Crash | Pods stuck in CrashLoopBackOff due to IP-in-IP routing & BGP misconfig in AWS VPC |
| ❌ No Pod Networking | Master & Worker nodes joined, but **no pod-to-pod network** |
| ❌ Manual kubeconfig & cert handling | Needed manual transfer of kubeconfig, tokens & certs |
| ❌ No Self-Healing | Unlike EKS, control plane failures required manual fixes |

> Instead of spending days debugging networking, I documented the architecture, root cause, and moved forward — because DevOps is about learning, iterating, and shipping fast.

---

## 💡 Why EKS is Better for Production

| Feature | Self-Managed (kubeadm) | AWS EKS |
|---------|--------------------------|---------|
| Control Plane | Manual setup & maintenance | Fully managed by AWS |
| Networking | Calico / Flannel config issues | AWS VPC CNI (works out of the box) |
| Upgrades | Manual & risky | One-click version upgrade |
| IAM Integration | Manual RBAC config | Native IAM for Service Accounts |
| Monitoring | Custom tools required | CloudWatch, audit logs built-in |

---

## 📌 Architecture Diagram

![Architecture of
kubeadm-aws-platform-engineering](/images/diagram-kubeadm-aws-platform-engineering.png)


---

## 🎯 Next Steps

- [ ] Migrate to **Terraform + AWS EKS**  
- [ ] Deploy **GCP Online Boutique microservices**  
- [ ] CI/CD using **GitHub Actions + Vault**  
- [ ] **Karpenter** for Auto-scaling  
- [ ] Integrate **SonarQube + Nexus + AWS ECR**

---

## 🤝 Contribute / Connect

Have ideas or want the code early? Let me know!

📬 **Connect on LinkedIn:** www.linkedin.com/in/kkintech15
⭐ **Star this repo** if you find it helpful!

---

## 🏷️ Tags

`#DevOps` `#Terraform` `#Ansible` `#Kubernetes` `#kubeadm` `#AWS` `#EKS` `#PlatformEngineering` `#IaC`

---

