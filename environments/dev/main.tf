locals {
  # Safe flattened map of all AKS-to-ACR attachments for AcrPull role assignments
  aks_acr_attachments = {
    for item in flatten([
      for aks_key, aks in var.aks_clusters : [
        for acr_key in aks.attached_acr_keys : {
          key     = "${aks_key}_to_${acr_key}"
          aks_key = aks_key
          acr_key = acr_key
        }
      ]
    ]) : item.key => item
  }

  # Pass AKS cluster definitions to the module
  aks_clusters_for_module = {
    for k, v in var.aks_clusters : k => {
      name                = v.name
      resource_group_name = v.resource_group_name
      location            = v.location
      dns_prefix          = v.dns_prefix
      kubernetes_version  = v.kubernetes_version
      sku_tier            = v.sku_tier
      default_node_pool   = v.default_node_pool
      identity_type       = v.identity_type
      network_profile     = v.network_profile
      tags                = v.tags
    }
  }
}

# 1. Resource Groups Module
module "resource_groups" {
  source          = "../../modules/azurerm_resource_group"
  resource_groups = var.resource_groups
}

# 2. Azure Container Registry Module
module "container_registries" {
  source               = "../../modules/azurerm_container_registry"
  container_registries = var.container_registries

  depends_on = [module.resource_groups]
}

# 3. Azure Kubernetes Service Module (System Assigned Managed Identity)
module "aks_clusters" {
  source       = "../../modules/azurerm_kubernetes_cluster"
  aks_clusters = local.aks_clusters_for_module

  depends_on = [module.resource_groups]
}

# 4. Role Assignment Module (AcrPull: System-Assigned Kubelet Identity -> ACR)
module "aks_acr_role_assignments" {
  source = "../../modules/azurerm_role_assignment"

  role_assignments = {
    for k, attachment in local.aks_acr_attachments : k => {
      principal_id                     = module.aks_clusters.kubelet_identities[attachment.aks_key]
      role_definition_name             = "AcrPull"
      scope                            = module.container_registries.container_registries[attachment.acr_key].id
      skip_service_principal_aad_check = true
    }
  }

  depends_on = [module.aks_clusters, module.container_registries]
}
