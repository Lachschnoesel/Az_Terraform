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

}
resource "azurerm_subnet" "firstsubnet" {
  name                 = "snet-first"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.first_addressspace]
}
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
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
resource "azurerm_network_security_group" "remote_access" {
  name                = "nsg-${var.application_name}-${var.instituion_name}-remoteaccess"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = data.http.my_ip.body
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "first_remote_access" {
  subnet_id                 = azurerm_subnet.firstsubnet.id
  network_security_group_id = azurerm_network_security_group.remote_access.id
}

data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

resource "azurerm_public_ip" "bastion" {
  name                = "pip-${var.application_name}-${var.instituion_name}-bastion"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "main" {
  name                = "examplebastion"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
