
data "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  resource_group_name = var.resource_group
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.aks_vnet.id
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "internal"
  resource_group_name  = var.resource_group
  virtual_network_name = var.aks_vnet_name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "jenkinsNic" {
  name                = "jenkins-nic"
  location            = var.azure_region
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.aks_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "jenkins" {
  name                = "jenkins-machine"
  resource_group_name = var.resource_group
  location            = var.azure_region
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.jenkinsNic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.sshkey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }
}