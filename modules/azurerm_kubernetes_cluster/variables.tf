variable "aks_clusters" {
  description = "Map of Azure Kubernetes Service cluster objects to create."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    dns_prefix          = optional(string)
    kubernetes_version  = optional(string)
    sku_tier            = optional(string, "Free")
    default_node_pool = optional(object({
      name                 = optional(string, "system")
      vm_size              = optional(string, "Standard_D2s_v3")
      node_count           = optional(number, 2)
      auto_scaling_enabled = optional(bool, false)
      min_count            = optional(number)
      max_count            = optional(number)
      os_disk_size_gb      = optional(number)
      vnet_subnet_id       = optional(string)
      type                 = optional(string, "VirtualMachineScaleSets")
      node_labels          = optional(map(string), {})
      tags                 = optional(map(string), {})
    }), {})
    identity_type = optional(string, "SystemAssigned")
    network_profile = optional(object({
      network_plugin = optional(string, "azure")
      network_policy = optional(string)
      dns_service_ip = optional(string)
      service_cidr   = optional(string)
      pod_cidr       = optional(string)
    }))
    tags = optional(map(string), {})
  }))
}
