resource "azurerm_resource_group" "az_rg_01" {
  name     = "rg-${var.application_name}-${var.instituion_name}"
  location = var.primary_region
}

resource "random_string" "storageaccount_suffix" {
  length  = 10
  upper   = false
  special = false
}

resource "azurerm_storage_account" "az_sa_01" {
  name                     = "st-${random_string.storageaccount_suffix.result}"
  resource_group_name      = azurerm_resource_group.az_rg_01.name
  location                 = azurerm_resource_group.az_rg_01.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}


resource "azurerm_storage_container" "blob_container_01" {
  name                  = "important"
  storage_account_id    = azurerm_storage_account.az_sa_01.id
  container_access_type = "private"
}
