resource "azapi_resource" "rg01" {
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "rg-${var.application_name}-${var.application_name}"
  location  = var.primary_region
  parent_id = "/subscriptions/${data.azapi_client_config.current_User.subscription_id}"
}

data "azapi_client_config" "current_User" {}
