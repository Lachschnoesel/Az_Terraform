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
data "azurerm_subnet" "first" {
  name                 = "snet-first"
  virtual_network_name = "vnet-network-dev"
  resource_group_name  = "rg-network-dev"
}


resource "azurerm_network_interface" "vm1" {
  name                = "example-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.first.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1.id
  }
}
resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
/*
resource "local_file" "private_key" {
  content         = tls_private_key.vm1.private_key_pem
  filename        = pathexpand("~/.ssh/vm1")
  file_permission = "0600"
}
resource "local_file" "public_key" {
  content         = tls_private_key.vm1.public_key_openssh
  filename        = pathexpand("~/.ssh/vm1.pub")
  file_permission = "0600"
}
*/

data "azurerm_key_vault" "main" {
  name                = "kv-devops-dev-dyffse"
  resource_group_name = "rg-devops-dev"
}

resource "azurerm_key_vault_secret" "main" {
  name         = "vm1-private-key"
  value        = tls_private_key.vm1.private_key_pem
  key_vault_id = data.azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "main" {
  name         = "vm1-public-key"
  value        = tls_private_key.vm1.public_key_openssh
  key_vault_id = data.azurerm_key_vault.main.id
}




resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm1${var.application_name}-${var.instituion_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_D2_v2_Promo"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vm1.id,
  ]

  identity {
    type = "SystemAssigned"
  }
  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.vm1.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "azurerm_virtual_machine_extension" "example" {
  name                       = "ext${azurerm_linux_virtual_machine.v1.name}"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm1.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

data "azurerm_client_config" "current" {
}

resource "azure_role_assignment" "entra_id_user_login" {
  scope                = azurerm_linux_virtual_machine.vm1.id
  role_definition_name = "Virtual Machien User Login"
  principal_id         = data.azurerm_client_config.current.object_id
}
