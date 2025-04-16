resource "azurerm_resource_group" "az_rg_01" {
  name     = "rg-${var.application_name}-${var.instituion_name}"
  location = "westus3"
}
