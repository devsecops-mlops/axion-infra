output "resource_groups" {
  description = "The map of created resource group resources."
  value       = azurerm_resource_group.rg
}

output "resource_group_ids" {
  description = "Map of resource group names to resource group IDs."
  value       = { for k, v in azurerm_resource_group.rg : k => v.id }
}

output "resource_group_names" {
  description = "Map of resource group keys to resource group names."
  value       = { for k, v in azurerm_resource_group.rg : k => v.name }
}
