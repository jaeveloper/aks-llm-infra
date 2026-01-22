resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.aks_name}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_name

  kubernetes_version  = null # let Azure pick stable default

  default_node_pool {
    name                = "system"
    vm_size             = var.node_vm_size
    node_count          = 1
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 2
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    project = "aks-llm-demo"
    owner   = "joshua"
  }
}

# GPU Node Pool for AKS
# resource "azurerm_kubernetes_cluster_node_pool" "gpu" {
  # name                  = "gpu"
  # kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  # vm_size               = "Standard_NC4as_T4_v3" # NVIDIA T4 GPU
  # enable_auto_scaling   = true
  # min_count             = 0                      # Min nodes for autoscaler
  # max_count             = 1                      # Max nodes (can scale later)
  # os_disk_size_gb       = 100
  # mode                  = "User"                 # Separate from system node pool

  # node_labels = {
    # "workload" = "gpu"
  # }

  # node_taints = [
    # "sku=gpu:NoSchedule"
  # ]
# }
