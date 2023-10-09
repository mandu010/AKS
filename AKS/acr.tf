resource "azurerm_container_registry" "acr" {

  name = "manduacr123"
  resource_group_name = var.resource_group
  location = var.azure_region
  sku = "Basic"
  admin_enabled = true
  
}

resource "azurerm_role_assignment" "acrpull" {
    scope = azurerm_container_registry.acr.id
    role_definition_name = "Acrpull"
    principal_id = data.azurerm_key_vault_secret.spn_id.value
    skip_service_principal_aad_check = true
}