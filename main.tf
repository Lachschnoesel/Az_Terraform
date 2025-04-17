resource "azurerm_resource_group" "az_rg_01" {
  name     = "rg-${var.application_name}-${var.instituion_name}"
  location = var.primary_region
}

resource "azurerm_storage_account" "az_sa_01" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.az_rg_01.name
  location                 = azurerm_resource_group.az_rg_01.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}
