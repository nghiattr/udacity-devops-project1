output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "name-jenkins-gitlab" {
  value = azurerm_linux_virtual_machine.jenkins-gitlab-sv.name

}

output "ippub-jenkins-gitlab" {
  value = azurerm_linux_virtual_machine.jenkins-gitlab-sv.public_ip_address
}


