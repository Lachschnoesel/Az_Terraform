data "azure_client_config" "current" {}

resource "azuread_group" "remote_access" {
  display_name     = "group${var.application_name}-${var.enviornment_name}"
  owners           = [data.azure_client_config.current.object_id]
  security_enabled = true
}
