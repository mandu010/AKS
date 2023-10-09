resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group
  location = var.azure_region
}