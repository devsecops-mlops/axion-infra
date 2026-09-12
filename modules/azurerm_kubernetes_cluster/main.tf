resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.aks_clusters

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = coalesce(each.value.dns_prefix, each.value.name)
  kubernetes_version  = each.value.kubernetes_version
  sku_tier            = each.value.sku_tier

  default_node_pool {
    name                 = each.value.default_node_pool.name
    vm_size              = each.value.default_node_pool.vm_size
    node_count           = each.value.default_node_pool.auto_scaling_enabled ? null : each.value.default_node_pool.node_count
    auto_scaling_enabled = each.value.default_node_pool.auto_scaling_enabled
    min_count            = each.value.default_node_pool.auto_scaling_enabled ? each.value.default_node_pool.min_count : null
    max_count            = each.value.default_node_pool.auto_scaling_enabled ? each.value.default_node_pool.max_count : null
    os_disk_size_gb      = each.value.default_node_pool.os_disk_size_gb
    vnet_subnet_id       = each.value.default_node_pool.vnet_subnet_id
    type                 = each.value.default_node_pool.type
    node_labels          = each.value.default_node_pool.node_labels
    tags                 = each.value.default_node_pool.tags
  }

  identity {
    type = each.value.identity_type
  }

  dynamic "network_profile" {
    for_each = each.value.network_profile != null ? [each.value.network_profile] : []
    content {
      network_plugin = network_profile.value.network_plugin
      network_policy = network_profile.value.network_policy
      dns_service_ip = network_profile.value.dns_service_ip
      service_cidr   = network_profile.value.service_cidr
      pod_cidr       = network_profile.value.pod_cidr
    }
  }

  tags = each.value.tags
}
