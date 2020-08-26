provider "azurerm" {
  version = ">=2.12.0"
  features {}
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "azure-dev"

    workspaces {
      name = "tf_management"
    }
  }
}

resource "azurerm_windows_virtual_machine" "win-host" {
  resource_group_name        = "management-rg"
  name                       = "win-host"
  computer_name              = "win-host"
  size                       = "Standard_DS1_v2"
  enable_automatic_updates   = true
  location                   = var.location
  admin_password             = var.admin_password
  admin_username             = var.admin_username
  allow_extension_operations = true
  priority                   = "Regular"
  provision_vm_agent         = true
  tags                       = {}

  network_interface_ids = [azurerm_network_interface.win-host.id]

  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = 127
    storage_account_type      = "StandardSSD_LRS"
    write_accelerator_enabled = false
  }

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
