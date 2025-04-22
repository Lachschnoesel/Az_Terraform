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
