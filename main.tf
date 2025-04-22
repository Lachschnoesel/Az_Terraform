resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.instituion_name}"
  location = var.primary_region
}
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.application_name}-${var.instituion_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.vnet-adressspace]
}

locals {
  first_addressspace  = cidrsubnet(var.vnet-adressspace, 2, 0)
  second_addressspace = cidrsubnet(var.vnet-adressspace, 2, 1)
  thrid_addressspace  = cidrsubnet(var.vnet-adressspace, 2, 0)
  forth_addressspace  = cidrsubnet(var.vnet-adressspace, 2, 0)
/*
}
resource "azurerm_subnet" "firstsubnet" {
  name                 = "snet-first"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.first_addressspace]
}
resource "azurerm_subnet" "secoundsubnet" {
  name                 = "snet-second"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.second_addressspace]
}
resource "azurerm_subnet" "thirdsubnet" {
  name                 = "snet-third"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.thrid_addressspace]
}
resource "azurerm_subnet" "forthsubnet" {
  name                 = "snet-forth"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.forth_addressspace] #each have 1/4 of the vnet, 251/255 addresses are aviable, 5 are preoccupied by azure
}

*/