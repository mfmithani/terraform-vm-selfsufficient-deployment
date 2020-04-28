
#it will prompt you to set the vm admin account password
variable "admin_password" {
  description = "Provide the virtual machine admin user account password."
}

#it will prompt you to set the vm admin account account name
variable "admin_username" {
  description = "Provide the virtual machine admin user account name."
}

#it will prompt you to set a prfix to append to all the resources provisioned
variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

#it will prompt you to set the vm deployment Azure Region
variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

provider "azurerm" {
version = "=2.0.0"
features {}

  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

variable "subscription_id" {
}

variable "client_id" {
}

variable "client_secret" {
}

variable "tenant_id" {
}
