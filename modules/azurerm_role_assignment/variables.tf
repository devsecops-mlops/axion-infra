variable "role_assignments" {
  description = "Map of Azure role assignments to create."
  type = map(object({
    principal_id                     = string
    role_definition_name             = string
    scope                            = string
    skip_service_principal_aad_check = optional(bool, true)
  }))
}
