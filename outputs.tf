output "app_service_default_hostname" {
  value = module.webapp.app_service_default_hostname
}

output "vm_public_ip" {
  value = module.vm.vm_public_ip
}

output "mysql_server_fqdn" {
  value = module.mysql.mysql_server_fqdn
}