output "aks_clusters" {
  description = "The map of created Azure Kubernetes Service cluster resources."
  value       = azurerm_kubernetes_cluster.aks
}

output "cluster_ids" {
  description = "Map of AKS cluster keys to cluster IDs."
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.id }
}

output "cluster_names" {
  description = "Map of AKS cluster keys to cluster names."
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.name }
}

output "kubelet_identities" {
  description = "Map of AKS cluster keys to their kubelet identity object IDs."
  value = {
    for k, v in azurerm_kubernetes_cluster.aks :
    k => v.kubelet_identity[0].object_id
  }
}

output "kube_config_raw" {
  description = "Map of AKS cluster keys to raw kube config."
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.kube_config_raw }
  sensitive   = true
}
