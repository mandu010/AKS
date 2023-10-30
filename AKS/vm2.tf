
resource "azurerm_public_ip" "testPublic1" {
  name                = "testPublic1"
  resource_group_name = "testrg2"
  location            = var.azure_region
  allocation_method   = "Dynamic"

}

resource "azurerm_network_interface" "testNic1" { #NIC
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
  resource_group_name = "testrg2"

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

resource "azurerm_network_interface_security_group_association" "test" {
  network_interface_id      = azurerm_network_interface.testNic1.id
  network_security_group_id = azurerm_network_security_group.testnsg.id
}



resource "azurerm_linux_virtual_machine" "testvm" {
  name                = "testvm"
  resource_group_name = "testrg2"
  location            = var.azure_region
  # size                = "Standard_F2"
  size           = "Standard_B1ls"
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