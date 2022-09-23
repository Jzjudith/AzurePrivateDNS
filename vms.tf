resource "azurerm_public_ip" "jmp" {
  name                = "jmp_pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}


#create network interface
resource "azurerm_network_interface" "nic" {
  name                = "jmpbx-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "jmpbx-ipconfig"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jmp.id
  }
}

resource "azurerm_network_interface" "nic1" {
  name                = "linux-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "nic-ipconfig1"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface" "nic2" {
  name                = "windows-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "nic-ipconfig2"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_linux_virtual_machine" "jmpbx" {
  name                  = "jumpbox"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = "Standard_B1s"
  admin_username        = "devlab"
  admin_password        = "Password123"
  network_interface_ids = [azurerm_network_interface.nic.id, ]


  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

}

resource "azurerm_linux_virtual_machine" "main1" {
  name                  = "devlinuxvm1"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = "Standard_B1s"
  admin_username        = "devlab"
  admin_password        = "Password123"
  network_interface_ids = [azurerm_network_interface.nic1.id, ]


  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

}

resource "azurerm_linux_virtual_machine" "main2" {
  name                  = "devlinuxvm2"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = "Standard_B1s"
  admin_username        = "devlab"
  admin_password        = "Password123"
  network_interface_ids = [azurerm_network_interface.nic2.id, ]


  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

}

