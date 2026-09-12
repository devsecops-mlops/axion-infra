output "container_registries" {
  description = "The map of created Azure Container Registry resources."
  value       = azurerm_container_registry.acr
}

output "acr_ids" {
  description = "Map of ACR keys to their Azure Resource IDs."
  value       = { for k, v in azurerm_container_registry.acr : k => v.id }
}

output "acr_login_servers" {
  description = "Map of ACR keys to their login servers."
  value       = { for k, v in azurerm_container_registry.acr : k => v.login_server }
}
