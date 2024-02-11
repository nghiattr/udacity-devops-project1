variable "resource_group_name" {
  default     = "Azuredevops"
  description = "Location of the resource group."
}

variable "resource_group_location" {
  default     = "East US"
  description = "Location of the resource group."
}

variable "count" {
  default     = "2"
  description = "Count"
}

variable "admin_username" {
  default     = "labadmin"
  description = "Admin username for all VMs"
}

variable "admin_password" {
  default     = "Password1234!"
  description = "Admin password for all VMs"
}