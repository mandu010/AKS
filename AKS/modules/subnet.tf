resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks_subnet"
  resource_group_name  = var.resource_group
  virtual_network_name = var.aks_vnet_name
  address_prefixes     = var.subnetcidr
}