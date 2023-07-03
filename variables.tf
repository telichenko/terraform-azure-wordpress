variable "resource_group_name" {
  default = "wp-resource-group"
}

variable "location" {
  default = "West Europe"
}

variable "vm_admin_username" {
  default = "frvr"
}

variable "vm_admin_password" {
  default = "sdafsdf"
}

variable "private_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "mysql_admin" {
  default = "frvr"
}

variable "mysql_password" {
  default = "sdaff"
}

variable "mysql_database_name" {
  default = "wp-db"
}

variable "vm_domain" {
  default = "telichenko.online"
}

variable "git_repo_url" {
  default = "https://github.com/WordPress/WordPress.git"
}

variable "git_branch" {
  default = "master"
}