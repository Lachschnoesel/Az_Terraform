resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.instituion_name}"
  location = var.primary_region
}
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.application_name}-${var.instituion_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.44.0.0/22"]
}
resource "azurerm_subnet" "firstsubnet" {
  name                 = "snet-first"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.44.0.0/24"]
}
