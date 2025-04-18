resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.instituion_name}"
  location = var.primary_region
}


resource "random_string" "keyvault_stuffix" {
  length  = 6
  upper   = false
  special = false

}
resource "azurerm_key_vault" "main" {
  name                = "kv-${var.application_name}-${var.instituion_name}-${random_string.keyvault_stuffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = "f761b35c-e362-4a79-95b0-70328476e5cf"
  sku_name            = "standard"
}
