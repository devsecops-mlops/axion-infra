variable "resource_groups" {
  description = "Map of resource group objects to create."
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  }))
}
