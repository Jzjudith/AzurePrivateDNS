# resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group
  location = var.location
}

# virtual network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = ["10.0.0.0/16"]
  depends_on = [
    azurerm_resource_group.main
  ]
}

# subnet
resource "azurerm_subnet" "main" {
  name                 = var.subnet
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_virtual_network.main
  ]
}

# private DNS zone
resource "azurerm_private_dns_zone" "main" {
  name                = "iveniinc.com"
  resource_group_name = var.resource_group
  depends_on = [
    azurerm_resource_group.main
  ]

}

# private DNS zone virtual network link
resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "dns-vnet-link"
  resource_group_name   = var.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled = true
  depends_on = [
    azurerm_private_dns_zone.main
  ]
}