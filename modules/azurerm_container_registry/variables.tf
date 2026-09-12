variable "container_registries" {
  description = "Map of Azure Container Registry objects to create."
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    sku                           = optional(string, "Standard")
    admin_enabled                 = optional(bool, false)
    public_network_access_enabled = optional(bool, true)
    tags                          = optional(map(string), {})
  }))
}
