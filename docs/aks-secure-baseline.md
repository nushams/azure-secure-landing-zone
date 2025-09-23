# AKS Secure Baseline

This document describes a **secure baseline architecture** for running **Azure Kubernetes Service (AKS)** in an enterprise-ready way.  
The goal is to ensure **network isolation, least-privilege identity, compliance controls, and operational visibility**.

---

## 1. Architecture Overview

### Hub-and-Spoke Network Design

- **Hub VNet**
  - Contains Bastion, optionally Azure Firewall, and private DNS zone.
- **Spoke VNet (Workload)**
  - Contains connectivity services.
  - Peered with the Hub VNet.

---

## 2. AKS Cluster Security

### Private Cluster

- AKS API server deployed with `private_cluster_enabled = true`.
- API server has only **private IP** within Spoke VNet.
- No public endpoint exposed.

### Network Access Control

- Instead of `authorized_ip_ranges`:
  - **NSG rules** on AKS subnet restrict traffic.
  - Only **Hub Bastion Subnet** can connect to API server.
  - Optional: enforce via **Azure Firewall** with DNAT and filtering.

### Node Pools

- **System node pool**: minimal size, runs only critical components.
- **User node pools**: taints + labels for workload separation.
- Enable **autoscaling**.

---

## 3. Identity & Access

### Cluster Authentication

- Enforce **Azure AD Integration** for RBAC.
- Map users and groups via RBAC roles.
- Use **least privilege** (developers get namespace-scoped roles, not cluster-admin).

### Workload Identity

- Prefer **Azure AD Workload Identity** for pods → Key Vault, Storage, DB.
- Replace managed identity mounting with workload identity for scalability.
- Rotate client credentials automatically.

---

## 4. Data Protection

### Key Vault

- All secrets stored in **Azure Key Vault**.
- Access only via workload identity (not hardcoded secrets).
- Optionally use **Azure Key Vault CSI Driver** for Kubernetes secrets injection.

### Storage

- Use **Azure Disk Encryption at Rest**.
- Ensure **EncryptionWithCustomerManagedKey (CMK)** if compliance requires.
- Disable public access for blob storage accounts.

---

## 5. Network Security

- **Ingress/Egress** via:
  - **Azure Firewall** or **NVA in Hub** (centralized).
  - Egress restrictions (only approved domains/IPs).
- **Private Endpoints** for DB, Storage, Key Vault.
- **Pod Security**:
  - Use **Network Policies** (Azure CNI + Calico).
  - Deny all → allow only namespace or app-specific communication.

---

## 6. Monitoring & Logging

- **Azure Monitor for Containers** enabled.
- Centralize logs to **Log Analytics Workspace**.
- Enable **Diagnostic Settings** on:

  - AKS cluster
  - Key Vault
  - Storage Accounts

- Configure **alerts** for:
  - Failed API server authentication attempts
  - Suspicious egress traffic
  - Excessive pod restarts

---

## 7. Compliance & Governance

- Enforce policies via **Azure Policy for AKS**:

  - Ensure only private clusters.
  - Disallow privileged containers.
  - Enforce HTTPS-only ingress.
  - Disallow public IPs on services.

- Use **Defender for Containers** for runtime threat detection.
- Apply **CIS AKS Benchmark** controls.

---

## 8. Terraform Baseline Modules

- **Networking**

  - Hub/Spoke VNet + Peering
  - Subnets (Bastion, AKS, Private Endpoints)
  - NSGs with explicit rules

- **Cluster**

  - Private AKS with Azure AD integration
  - System + User node pools
  - Workload Identity

- **Security**
  - Key Vault + CSI driver
  - Private Endpoints
  - Azure Policy assignments

---

## References

- [Private Cluster Considerations](https://learn.microsoft.com/azure/aks/private-clusters)
- [Azure Security Benchmark for AKS](https://learn.microsoft.com/security/benchmark/azure/baselines/aks-security-baseline)

---
