variable "location" {
  description = "Azure region for deployment"
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group name"
  default     = "azure-lab-rg-${random_integer.suffix.result}"
}



variable "prefix" {
  description = "Prefix for naming resources"
  default     = "lab"
}

variable "vnet_cidr" {
  description = "CIDR block for VNet"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
  default     = "10.0.1.0/24"
}

variable "vm_size" {
  description = "Size of the lab VM"
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username"
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for Windows VM"
  default = "Admin@123"
#  type        = string
#  sensitive   = true
}
