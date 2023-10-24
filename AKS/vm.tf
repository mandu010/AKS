

resource "azurerm_public_ip" "jenkinsPublic" {
  name                = "jenkinspublicip"
  resource_group_name = var.resource_group
  location            = var.azure_region
  allocation_method   = "Dynamic"

}

resource "azurerm_network_interface" "jenkinsNic" {
  name                = "jenkins-nic"
  location            = var.azure_region
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.aks_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkinsPublic.id
  }
}

resource "azurerm_network_security_group" "jenkins_nsg" {
  name                = "jenkinsnetworkgroup"
  location            = var.azure_region
  resource_group_name = var.resource_group

  security_rule {
    name                       = "jenkinsnsg"
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
  network_interface_id      = azurerm_network_interface.jenkinsNic.id
  network_security_group_id = azurerm_network_security_group.jenkins_nsg.id
}

data "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  resource_group_name = var.resource_group
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.aks_vnet.id
}

resource "azurerm_linux_virtual_machine" "jenkins" {
  name                = "jenkins-machine2"
  resource_group_name = var.resource_group
  location            = var.azure_region
  # size                = "Standard_F2"
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
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}