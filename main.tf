resource "azurerm_resource_group" "lab_rg" {
  name     = "${var.resource_group_prefix}-${random_integer.suffix.result}"
  location = var.location
}


variable "resource_group_prefix" {
  description = "Prefix for resource group"
  default     = "azure-lab-rg"
}

resource "azurerm_virtual_network" "lab_vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
}

resource "azurerm_subnet" "lab_subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.lab_rg.name
  virtual_network_name = azurerm_virtual_network.lab_vnet.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_network_security_group" "lab_nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"  # RDP port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "lab_pip" {
  name                = "${var.prefix}-pip"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "lab_nic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab_pip.id
  }
}

resource "azurerm_windows_virtual_machine" "lab_vm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.lab_rg.location
  resource_group_name   = azurerm_resource_group.lab_rg.name
  network_interface_ids = [azurerm_network_interface.lab_nic.id]
  size                  = var.vm_size

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  computer_name  = "${var.prefix}-vm"
  admin_username = var.admin_username
  admin_password = var.admin_password  # Note: Password-based login for Windows VM

  # You can optionally enable automatic updates, diagnostics, etc.

  tags = {
    environment = "lab"
  }
}
