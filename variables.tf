variable "location" {
  description = "Azure region"
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group name"
  default     = "az104-lab-rg"
}

variable "vnet_name" {
  description = "Virtual Network name"
  default     = "az104-lab-vnet"
}

variable "vnet_cidr" {
  description = "Virtual Network address space"
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "Subnet name"
  default     = "az104-lab-subnet"
}

variable "subnet_cidr" {
  description = "Subnet address prefix"
  default     = "10.0.1.0/24"
}

variable "nsg_name" {
  description = "Network Security Group name"
  default     = "az104-lab-nsg"
}

variable "public_ip_name" {
  description = "Public IP name"
  default     = "az104-lab-pip"
}

variable "nic_name" {
  description = "Network Interface Card name"
  default     = "az104-lab-nic"
}

variable "vm_name" {
  description = "Virtual Machine name"
  default     = "az104-lab-vm"
}

variable "admin_username" {
  description = "Admin username for VM"
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for VM"
  type        = string
  sensitive   = true
}
