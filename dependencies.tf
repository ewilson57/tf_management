resource "azurerm_resource_group" "management" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "management" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.2.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.management.name
}

resource "azurerm_network_security_group" "management" {
  name                = "Base"
  location            = var.location
  resource_group_name = azurerm_resource_group.management.name

  security_rule {
    name              = "default"
    priority          = 100
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    destination_port_ranges = [
      "22",
      "80",
      "3389"
    ]
    source_address_prefix      = var.router_wan_ip
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Management"
  }
}

resource "azurerm_subnet" "management" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.management.name
  virtual_network_name = azurerm_virtual_network.management.name
  address_prefixes     = ["10.2.0.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

resource "azurerm_public_ip" "win-host" {
  name                = "win-host-publicip"
  resource_group_name = azurerm_resource_group.management.name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "win-host" {
  name                = "win-host-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.management.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.win-host.id
  }
}


