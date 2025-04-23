data "azuread_client_config" "current" {}

resource "azuread_group" "remote_access" {
  display_name     = "group${var.application_name}-${var.instituion_name}"
  owners           = [data.azure_client_config.current.object_id]
  security_enabled = true
}

resource "azuread_group_member" "daniel_is_in_the_group" {
  group_object_id  = azuread_group.remote_access_users.object_id
  member_object_id = data.azuread_client_config.current.object_id
}
