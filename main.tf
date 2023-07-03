resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  vnet_name           = "wp-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  vnet_address_space  = ["10.0.0.0/16"]
  subnet_name         = "wp-subnet"
  subnet_address_prefixes = ["10.0.1.0/24"]
}

module "webapp" {
  source              = "./modules/webapp"
  app_service_plan_name = "wp-app-service-plan"
  app_service_name     = "wp-app-service"
  location             = var.location
  resource_group_name  = azurerm_resource_group.example.name
  mysql_server         = module.mysql.mysql_server_fqdn
  mysql_admin          = var.mysql_admin
  mysql_password       = var.mysql_password
  mysql_database       = var.mysql_database_name
  git_repo_url         = var.git_repo_url
  git_branch           = var.git_branch
}

module "vm" {
  source                    = "./modules/vm"
  vm_name                   = "wp-vm"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.example.name
  subnet_id                 = module.network.subnet_id
  vm_admin_username         = var.vm_admin_username
  vm_admin_password         = var.vm_admin_password
  private_key_path          = var.private_key_path
  vm_domain                 = var.vm_domain
  wordpress_app_service_url = module.webapp.app_service_default_hostname
  ssl_certificate_path      = "${path.module}/modules/vm/ssl_certificate.crt"
  ssl_certificate_key_path  = "${path.module}/modules/vm/ssl_certificate.key"
}

module "mysql" {
  source              = "./modules/mysql"
  mysql_server_name   = "wp-mysql-server01072023-01"
  mysql_database_name = "wp-db"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  mysql_admin         = var.mysql_admin
  mysql_password      = var.mysql_password
}