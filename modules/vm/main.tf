resource "azurerm_public_ip" "example" {
  name                = "publicip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

data "azurerm_public_ip" "example" {
  name                = azurerm_public_ip.example.name
  resource_group_name = azurerm_public_ip.example.resource_group_name
  depends_on          = [azurerm_public_ip.example]
}

resource "azurerm_network_interface" "example" {
  name                = "nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.example.id]
  size                  = "Standard_B1s"

  admin_username = var.vm_admin_username
  admin_password = var.vm_admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  disable_password_authentication = false

  custom_data = base64encode(templatefile("${path.module}/setup.sh", {
    nginx_config              = templatefile("${path.module}/nginx.tpl", { vm_domain = var.vm_domain, wordpress_app_service_url = var.wordpress_app_service_url }),
    vm_domain                 = var.vm_domain,
  }))

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.example.ip_address
    user        = var.vm_admin_username
    password    = var.vm_admin_password
    private_key = file("~/.ssh/id_rsa")
    agent       = false
    timeout     = "1m"
  }

  provisioner "file" {
    source      = var.ssl_certificate_path
    destination = "/tmp/ssl_certificate.crt"
  }

  provisioner "file" {
    source      = var.ssl_certificate_key_path
    destination = "/tmp/ssl_certificate.key"
  }

}