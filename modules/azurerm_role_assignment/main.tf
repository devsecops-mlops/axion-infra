resource "azurerm_role_assignment" "ra" {
  for_each = var.role_assignments

  principal_id                     = each.value.principal_id
  role_definition_name             = each.value.role_definition_name
  scope                            = each.value.scope
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check

  lifecycle {
    ignore_changes = [skip_service_principal_aad_check]
  }
}
