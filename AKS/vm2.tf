resource "azurerm_resource_group" "testrg2" {
  name     = "testrg2"
  location = var.azure_region
}

resource "azurerm_virtual_network" "testvnet1" {
  name                = "testvnet1"
  resource_group_name = "testrg2"
  location            = var.azure_region
  address_space       = ["20.0.0.0/24"]
}

resource "azurerm_subnet" "testsubnet" {
  name                 = "testsubnet"
  resource_group_name  = "testrg2"
  virtual_network_name = "testvnet1"
  address_prefixes     = ["20.0.0.0/25"]
}

resource "azurerm_public_ip" "testPublic1" {
  name                = "testPublic1"
  resource_group_name = var.resource_group
  location            = var.azure_region
  allocation_method   = "Dynamic"

}

resource "azurerm_network_interface" "testNic1" {
  name                = "testNic1"
  location            = var.azure_region
  resource_group_name = "testrg2"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.testsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.testPublic1.id
  }
}

resource "azurerm_network_security_group" "testnsg" {
  name                = "testnsg"
  location            = var.azure_region
  resource_group_name = var.resource_group

  security_rule {
    name                       = "testnsg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.testNic1.id
  network_security_group_id = azurerm_network_security_group.testnsg.id
}

data "azurerm_virtual_network" "aks_vnet" {
  name                = "testvnet1"
  resource_group_name = "testrg2"
}


resource "azurerm_linux_virtual_machine" "testvm" {
  name                = "testvm"
  resource_group_name = "testrg2"
  location            = var.azure_region
  # size                = "Standard_F2"
  size           = "Standard_B1"
  admin_username = "adminuser"
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
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}