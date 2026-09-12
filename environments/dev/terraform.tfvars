# ==========================================
# Resource Groups
# ==========================================
resource_groups = {
  rg_dev = {
    name     = "rg-microservices-dev"
    location = "eastus"
    tags = {
      Environment = "development"
      Project     = "Axion-Microservices"
      ManagedBy   = "Terraform"
    }
  }
}

# ==========================================
# Azure Container Registries (ACR)
# Note: ACR name must be 5-50 alphanumeric lowercase chars only
# ==========================================
container_registries = {
  acr_dev = {
    name                          = "axionmicrodevacr"
    resource_group_name           = "rg-microservices-dev"
    location                      = "eastus"
    sku                           = "Standard"
    admin_enabled                 = false
    public_network_access_enabled = true
    tags = {
      Environment = "development"
      Project     = "Axion-Microservices"
      ManagedBy   = "Terraform"
    }
  }
}

# ==========================================
# Azure Kubernetes Service (AKS)
# Using System Assigned Managed Identity
# ==========================================
aks_clusters = {
  aks_dev = {
    name                = "aks-microservices-dev"
    resource_group_name = "rg-microservices-dev"
    location            = "eastus"
    dns_prefix          = "aks-microservices-dev"
    kubernetes_version  = "1.35"
    sku_tier            = "Free"

    # System-Assigned Managed Identity
    identity_type = "SystemAssigned"

    default_node_pool = {
      name                 = "system"
      vm_size              = "Standard_D2s_v3"
      node_count           = 2
      auto_scaling_enabled = false
      os_disk_size_gb      = 30
      type                 = "VirtualMachineScaleSets"
      node_labels = {
        "nodepool-type" = "system"
        "environment"   = "dev"
      }
      tags = {
        Environment = "development"
        Role        = "system-nodes"
      }
    }

    network_profile = {
      network_plugin = "azure"
      network_policy = "calico"
    }

    # Automatically grant AcrPull permission to this AKS cluster's Kubelet System Managed Identity
    attached_acr_keys = ["acr_dev"]

    tags = {
      Environment = "development"
      Project     = "Axion-Microservices"
      ManagedBy   = "Terraform"
    }
  }
}
