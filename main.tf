resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.instituion_name}"
  location = var.primary_region
}
data "azurerm_client_config" "current" {}

resource "random_string" "keyvault_stuffix" {
  length  = 6
  upper   = false
  special = false

}
resource "azurerm_key_vault" "main" {
  name                = "kv-${var.application_name}-${var.instituion_name}-${random_string.keyvault_stuffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azure_client_config.current.tenant.id
  sku_name            = "standard"
}

resource "azurerm_role_assignment" "terraform_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
