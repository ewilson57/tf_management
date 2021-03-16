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

  network_interface_ids = [
    azurerm_network_interface.win-host.id
  ]

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

resource "azurerm_linux_virtual_machine" "ol8" {
  name     = "ol8"
  location = "southcentralus"

  resource_group_name = "management-rg"
  computer_name       = "ol8"
  admin_username      = "spyro"
  admin_password      = null
  admin_ssh_key {
    public_key = var.admin_ssh_key
    username   = "spyro"
  }
  priority           = "Regular"
  provision_vm_agent = true
  size               = "Standard_DS1_v2"
  source_image_reference {
    offer     = "Oracle-Linux"
    publisher = "Oracle"
    sku       = "ol83-lvm"
    version   = "latest"
  }
  network_interface_ids = [
    azurerm_network_interface.ol8.id
  ]

  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = 30
    storage_account_type      = "StandardSSD_LRS"
    write_accelerator_enabled = false
  }
}
