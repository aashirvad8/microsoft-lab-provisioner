terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatejayesh4890patil1"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
