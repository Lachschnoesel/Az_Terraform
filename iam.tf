data "azuread_client_config" "current" {}

resource "azuread_group" "remote_access" {
  display_name     = "group${var.application_name}-${var.instituion_name}"
  owners           = [data.azure_client_config.current.object_id]
  security_enabled = true
}

locals {
  remote_access_users_map = { for idx, element in var.remote_access_users : element => idx }
}

resource "azuread_group_member" "user_is_in_the_group" {
  for_each         = local.remote_access_users.map
  group_object_id  = azuread_group.remote_access_users.object_id
  member_object_id = data.azuread_user.remote_access_users[each.key].object_id
}

data "azuread_user" "USERS" {
  for_each            = local.remote_access_users_map
  user_principal_name = each.key
}
