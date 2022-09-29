# jumo box public ip address
resource "azurerm_public_ip" "jmp" {
  name                = "jmp_pip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"

  depends_on = [
    azurerm_resource_group.main
  ]
}

# network interfaces
resource "azurerm_network_interface" "nic" {
  name                = "jmpbx-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "jmpbx-ipconfig"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jmp.id
  }

  depends_on = [
    azurerm_subnet.main
  ]
}

resource "azurerm_network_interface" "main" {
  count               = 2
  name                = "vm-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"

  }

  depends_on = [
    azurerm_subnet.main
  ]
}

# virtual machines
resource "azurerm_linux_virtual_machine" "jmpbx" {
  name                  = "jumpbox"
  resource_group_name   = var.resource_group
  location              = var.location
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

depends_on = [
  azurerm_network_interface.main
]
}

resource "azurerm_linux_virtual_machine" "main" {
  count                 = 2
  name                  = "devlab-vm-${count.index}"
  resource_group_name   = var.resource_group
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = "devlab"
  admin_password        = "Password123"
  network_interface_ids = [element(azurerm_network_interface.main.*.id, count.index), ]
  # network_interface_ids           = [element([for nic in azurerm_network_interface.main : nic.id], count.index), ]

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
  
depends_on = [
  azurerm_network_interface.main
]
}


