resource "azurerm_network_security_group" "nsg" {
  name                = "dev-test-nsg"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  security_rule {
    name                       = "Allow-SSH-Access"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "10.0.0.0/16" # "VirtualNetwork"
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow-HTTP-Access"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "10.0.0.0/16" # "VirtualNetwork"
    destination_port_range     = "80"
  }


  security_rule {
    name                       = "Allow-rdp-Access"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "10.0.0.0/16" # "VirtualNetwork"
    destination_port_range     = "3389"
  }
}
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
