output "resource_group_names" {
  description = "Names of the created Resource Groups."
  value       = module.resource_groups.resource_group_names
}

output "resource_group_ids" {
  description = "IDs of the created Resource Groups."
  value       = module.resource_groups.resource_group_ids
}

output "container_registry_login_servers" {
  description = "Login servers for the created Azure Container Registries."
  value       = module.container_registries.acr_login_servers
}

output "container_registry_ids" {
  description = "Resource IDs for the created Azure Container Registries."
  value       = module.container_registries.acr_ids
}

output "aks_cluster_names" {
  description = "Names of the created AKS clusters."
  value       = module.aks_clusters.cluster_names
}

output "aks_kubelet_identities" {
  description = "Kubelet Managed Identity Object IDs for AKS clusters (used for AcrPull)."
  value       = module.aks_clusters.kubelet_identities
}

output "aks_kube_config_raw" {
  description = "Raw kube config for connecting to AKS clusters."
  value       = module.aks_clusters.kube_config_raw
  sensitive   = true
}
