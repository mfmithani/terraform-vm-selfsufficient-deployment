resource "azurerm_resource_group" "main" {
  name               = "${var.prefix}-resources3"
  location           = var.location

	    tags = 	{
	      Environments    = "Dev"
	      Teams           = "DevOps"
	      Location        = "NYC"
        Classification  = "Resource Group"
		        }
}
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

	    tags = 	{
	      Environments    = "Dev"
	      Teams           = "DevOps"
	      Location        = "NYC"
        Classification  = "Virtual Network"
		          }
}
resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-internal-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.1.0/24"
}
resource "azurerm_public_ip" "PublicIp" {
  name 			            = "${var.prefix}-PublicIp"
  location		          = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  allocation_method	    = "Dynamic"
}
resource "azurerm_network_security_group" "NSG" {
    name                = "${var.prefix}-NSG"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    tags = 	{
        Environments    = "Dev"
	      Teams           = "DevOps"
	      Location        = "NYC"
        Classification  = "NSG"
            }
}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg-association" {
    network_interface_id      = azurerm_network_interface.main.id
    network_security_group_id = azurerm_network_security_group.NSG.id
}
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group_name = azurerm_resource_group.main.name
    }
    byte_length = 8
}
resource "azurerm_storage_account" "StorageAccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.main.name
    location                    = azurerm_resource_group.main.location
    account_replication_type    = "LRS"
    account_tier                = "Standard"
    tags = 	{
        Environments    = "Dev"
	      Teams           = "DevOps"
	      Location        = "NYC"
        Classification  = "Storage Account"
            }
}
resource "azurerm_network_interface" "main" {
  name                			        = "${var.prefix}-nic"
  resource_group_name 			        = azurerm_resource_group.main.name
  location            			        = azurerm_resource_group.main.location
  
  ip_configuration {
    name                          	= "${var.prefix}-InternalIp"
    subnet_id                     	= azurerm_subnet.internal.id
    private_ip_address_allocation 	= "Dynamic"   
    public_ip_address_id            = azurerm_public_ip.PublicIp.id          
  } 
        
    tags = 	{
        Environments    = "Dev"
	      Teams           = "DevOps"
	      Location        = "NYC"
        Classification  = "Virtual Network Interface"
            }
}
resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_F2"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}