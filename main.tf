resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.instituion_name}"
  location = var.primary_region
}

resource "azurerm_public_ip" "vm1" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}
data "azurerm_subnet" "first" {
  name                 = "snet-first"
  virtual_network_name = "vnet-network-dev"
  resource_group_name  = "rg-network-dev"
}


resource "azurerm_network_interface" "vm1" {
  name                = "example-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.first.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1.id
  }
}
resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
