provider "azurerm" {
  features {}
}

# resource "azurerm_resource_group" "rg" {
#   name     = var.resource_group_name
#   location = var.resource_group_location
# }

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "myVnet-assign2"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  
  tags = {
    source = var.custom_tags
  }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet-assign2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "myPublicIP-assign2"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
    
  tags = {
    source = var.custom_tags
  }
}

resource "azurerm_public_ip" "myterraformpublicip3" {
  name                = "myPublicIP-assign3"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
    
  tags = {
    source = var.custom_tags
  }
}

# Create a Load Balancer
resource "azurerm_lb" "lb" {
  name                = "loadBalancer"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.myterraformpublicip.id
  }

  tags = {
    source = var.custom_tags
  }
}

# Create a LoadBalancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "lbbap" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "myNSG-assign2"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  #Rule to deny inbound traffic from the internet
  security_rule {
    name                       = "DenyInternetInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = {
    source = var.custom_tags
  }
}

# NIC for VM 
resource "azurerm_network_interface" "myterraformnic" {
  name                = "myNIC-assign2"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "myNicConfiguration-assign2"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip3.id
  }
    
  tags = {
    source = "NghiaUdacitylab"
  }
}

# NIC for VM 2
resource "azurerm_network_interface" "myterraformnic3" {
  name                = "myNIC-assign3"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "myNicConfiguration-assign3"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    source = var.custom_tags
  }
}

# Connect the subnet to the network security group
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.myterraformsubnet.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

data "azurerm_image" "custom" {
  name                = var.custom_image_name
  resource_group_name = var.resource_group_name
}

# Create virtual machine Linux for udacity-vm-lab
resource "azurerm_virtual_machine" "udacity-vm-lab" {
  name                  = "udacity-vm-lab"
  count                 = var.instance_count
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  vm_size               = "Standard_B2ms"

  storage_image_reference {
    id = data.azurerm_image.custom.id
  }

  os_profile {
    computer_name  = "udacity-vm-lab"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  storage_os_disk {
    name                 = "myOsDisk-assign"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Standard_LRS"
  }

  tags = {
    source = var.custom_tags
  }
}

# Try to add the VM without Tags for Tags Policy testing.
resource "azurerm_virtual_machine" "udacity-vm-lab2" {
  name                  = "udacity-vm-lab2"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.myterraformnic3.id]
  vm_size               = "Standard_B2ms"

  storage_image_reference {
    id = data.azurerm_image.custom.id
  }

  os_profile {
    computer_name  = "udacity-vm-lab2"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  storage_os_disk {
    name                 = "myOsDisk-assign2"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Standard_LRS"
  }
}