resource "azurerm_app_service_plan" "example" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "example" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    linux_fx_version = "PHP|7.4"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WORDPRESS_DB_HOST                   = var.mysql_server
    WORDPRESS_DB_USER                   = var.mysql_admin
    WORDPRESS_DB_PASSWORD               = var.mysql_password
    WORDPRESS_DB_NAME                   = var.mysql_database
  }
}

resource "null_resource" "configure_git_deployment" {
  depends_on = [azurerm_app_service.example]

  provisioner "local-exec" {
    command = "az webapp deployment source config --name ${var.app_service_name} --resource-group ${var.resource_group_name} --repo-url ${var.git_repo_url} --branch ${var.git_branch} --manual-integration"
  }
}
