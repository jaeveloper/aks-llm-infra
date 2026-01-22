variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-aks-llm-demo"
}

variable "aks_name" {
  description = "AKS cluster name"
  type        = string
  default     = "aks-llm-demo"
}

variable "node_vm_size" {
  description = "VM size for system node pool"
  type        = string
  default     = "Standard_DC2as_v5"
}

