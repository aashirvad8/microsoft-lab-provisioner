# main.tf

provider "azurerm" {
  features {}
  subscription_id = "d0866d00-eb92-4775-bfeb-d6fc94acd94e"
}


# Fetch existing RG if it exists
data "azurerm_resource_group" "existing" {
  count = var.resource_group_exists ? 1 : 0
  name  = var.resource_group_name
}

# Create RG only if it doesn't exist
resource "azurerm_resource_group" "lab" {
  count    = var.resource_group_exists ? 0 : 1
  name     = var.resource_group_name
  location = var.location
}

# Local values to unify resource group name and location references
locals {
  rg_name     = var.resource_group_exists ? data.azurerm_resource_group.existing[0].name : azurerm_resource_group.lab[0].name
  rg_location = var.resource_group_exists ? data.azurerm_resource_group.existing[0].location : azurerm_resource_group.lab[0].location
}

resource "azurerm_virtual_network" "lab_vnet" {
  name                = var.vnet_name
  resource_group_name = local.rg_name
  location            = local.rg_location
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "lab_subnet" {
  name                 = var.subnet_name
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.lab_vnet.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_network_security_group" "lab_nsg" {
  name                = var.nsg_name
  location            = local.rg_location
  resource_group_name = local.rg_name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "lab_assoc" {
  subnet_id                 = azurerm_subnet.lab_subnet.id
  network_security_group_id = azurerm_network_security_group.lab_nsg.id
}

resource "azurerm_public_ip" "lab_pip" {
  name                = var.public_ip_name
  location            = local.rg_location
  resource_group_name = local.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "lab_nic" {
  name                = var.nic_name
  location            = local.rg_location
  resource_group_name = local.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab_pip.id
  }
}

resource "azurerm_windows_virtual_machine" "lab_vm" {
  name                  = var.vm_name
  resource_group_name   = local.rg_name
  location              = local.rg_location
  size                  = "Standard_B1ls"
  network_interface_ids = [azurerm_network_interface.lab_nic.id]
  admin_username        = var.admin_username
  admin_password        = var.admin_password

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

  tags = {
    environment = "az104-lab"
  }
}