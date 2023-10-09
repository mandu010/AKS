resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  resource_group_name = var.resource_group
  location            = var.azure_region
  address_space       = var.vnetcidr
} 