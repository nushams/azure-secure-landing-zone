variable "cluster_name" {
  type        = string
  description = "aks cluster name"
  default     = "cluster_aks"
}

variable "k8s_version" {
  type        = string
  description = "kubernetes version"
  default     = "1.33"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID"
}

variable "location" {
  type        = string
  description = "Default region"
}

variable "az_rg_name" {
  type        = string
  description = "Azure resource group name where the aks cluster should be created"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix specified when creating the managed cluster. Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length. Changing this forces a new resource to be created."
  default     = "platform"
}

variable "az_subnet_id" {
  type        = string
  description = "azure subnet id where the nodepools and aks cluster need to be created"
}

variable "network_plugin" {
  type        = string
  description = "Network plugin to use for networking. Currently supported values are azure, kubenet and none. Changing this forces a new resource to be created."
  default     = "azure"
}

variable "aks_tags" {
  type        = map(any)
  description = "tags for the aks cluster"
  default     = {}
}

variable "nodepools" {
  description = "Nodepools for the Kubernetes cluster"
  type = map(object({
    name                  = string
    zones                 = list(number)
    vm_size               = string
    min_count             = number
    max_count             = number
    enable_auto_scaling   = bool
    enable_node_public_ip = bool
    tags                  = map(string)
    node_labels           = map(string)
  }))
  default = {
    worker = {
      name                  = "worker"
      zones                 = [3]
      vm_size               = "standard_a2_v2"
      min_count             = 1
      max_count             = 3
      enable_auto_scaling   = true
      enable_node_public_ip = true
      tags                  = { worker_name = "worker" }
      node_labels           = { "worker-name" = "worker" }
    }
  }
}

variable "workload_sa_name" {
  type        = string
  description = "Kubernetes service account to permit"
  default     = "aks-wl-sa"
}

variable "workload_sa_namespace" {
  type        = string
  description = "Kubernetes service account namespace to permit"
  default     = "aks-wl-sa-ns"
}
